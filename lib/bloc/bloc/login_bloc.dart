import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fix_mates_user/view/opening_screens/login_screen.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<SendOtpPressed>(_onSendOtpPressed);
  }

  void _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<LoginState> emit) {
    if (event.phoneNumber.length == 10) {
      emit(PhoneNumberValid());
    } else {
      emit(PhoneNumberInvalid());
    }
  }

  Future<void> _onSendOtpPressed(
      SendOtpPressed event, Emitter<LoginState> emit) async {
    try {
      bool isUserAvailable = await _checkUserAvailable(event.phoneNumber);
      log("$isUserAvailable");

      if (isUserAvailable) {
        emit(OtpSent());
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91${event.phoneNumber}",
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            emit(LoginError(e.message ?? 'Verification failed'));
          },
          codeSent: (String verificationId, int? resendToken) {
            LoginScreen.verify = verificationId;
            print('OTP sent, verificationId: $verificationId'); // Debug print
            emit(OtpSent());
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        emit(UserNotFound());
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<bool> _checkUserAvailable(String phone) async {
    try {
      QuerySnapshot obj = await FirebaseFirestore.instance
          .collection('usersDetails')
          .where('userPhone', isEqualTo: phone)
          .get();

      return obj.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check user availability');
    }
  }
}
