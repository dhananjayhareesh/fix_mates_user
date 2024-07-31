// user_details_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc() : super(UserDetailsInitial()) {
    on<UserDetailsSubmitted>(_onUserDetailsSubmitted);
    on<PhoneVerificationRequested>(_onPhoneVerificationRequested);
  }

  Future<void> _onUserDetailsSubmitted(
      UserDetailsSubmitted event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsSubmissionInProgress());
    try {
      final CollectionReference firebaseUsersInstance =
          FirebaseFirestore.instance.collection('usersDetails');
      final data = {
        'userEmail': event.email,
        'userName': event.name,
        'userPhone': event.phone,
      };
      await firebaseUsersInstance.add(data);
      emit(UserDetailsSubmissionSuccess());
    } catch (e) {
      emit(UserDetailsSubmissionFailure(e.toString()));
    }
  }

  Future<void> _onPhoneVerificationRequested(
      PhoneVerificationRequested event, Emitter<UserDetailsState> emit) async {
    emit(PhoneVerificationInProgress());
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + event.phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          emit(PhoneVerificationFailure(e.message ?? 'Verification failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(PhoneVerificationSuccess(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(PhoneVerificationFailure(e.toString()));
    }
  }
}
