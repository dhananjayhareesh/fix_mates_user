import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'booking_conformation_event.dart';
part 'booking_conformation_state.dart';

class BookingConformationBloc
    extends Bloc<BookingConformationEvent, BookingConformationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BookingConformationBloc() : super(BookingConformationInitial()) {
    on<BookingConformationEvent>((event, emit) async {
      emit(BookingConformationLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userDocId = prefs.getString('userDocId');
        if (userDocId != null) {
          final userDoc =
              await _firestore.collection('usersDetails').doc(userDocId).get();
          if (userDoc.exists) {
            final locationName = userDoc.get('locationName') as String?;
            emit(
                BookingConformationLoaded(locationName ?? 'No Location Found'));
          } else {
            emit(BookingConformationError('Please set location'));
          }
        } else {
          emit(BookingConformationError('User Location not found'));
        }
      } catch (e) {
        emit(BookingConformationError('Error fetching location: $e'));
      }
    });
  }
}
