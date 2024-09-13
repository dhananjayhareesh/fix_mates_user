import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'booking_details_event.dart';
part 'booking_details_state.dart';

class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  BookingDetailsBloc() : super(BookingDetailsInitial()) {
    on<FetchUserBookings>(_onFetchUserBookings);
    on<FetchBookingDetail>(_onFetchBookingDetail);
    on<PaymentSuccessRebuildEvent>(paymentSuccessRebuildEvent);
  }

  Future<void> _onFetchUserBookings(
      FetchUserBookings event, Emitter<BookingDetailsState> emit) async {
    try {
      emit(BookingDetailsLoading());

      final bookingQuerySnapshot = await FirebaseFirestore.instance
          .collection('Bookings')
          .where('userId', isEqualTo: event.userDocId)
          .get();

      final bookings =
          await Future.wait(bookingQuerySnapshot.docs.map((doc) async {
        final booking = doc.data();

        // Fetch worker details
        if (booking.containsKey('workerId') && booking['workerId'] != null) {
          final workerDoc = await FirebaseFirestore.instance
              .collection('workers')
              .doc(booking['workerId'])
              .get();

          if (workerDoc.exists) {
            final workerData = workerDoc.data()!;
            booking['workerName'] = workerData['userName'] ?? 'Unknown';
            booking['workerCategory'] = workerData['category'] ?? 'Unknown';
          } else {
            booking['workerName'] = 'Unknown';
            booking['workerCategory'] = 'Unknown';
          }
        } else {
          booking['workerName'] = 'Unknown';
          booking['workerCategory'] = 'Unknown';
        }

        booking['id'] = doc.id; // Add document ID to the booking data
        return booking;
      }).toList());

      emit(BookingDetailsLoaded(bookings));
    } catch (e) {
      emit(BookingDetailsError('Failed to fetch user bookings.'));
    }
  }

  Future<void> _onFetchBookingDetail(
      FetchBookingDetail event, Emitter<BookingDetailsState> emit) async {
    try {
      emit(BookingDetailsLoading());

      final docSnapshot = await FirebaseFirestore.instance
          .collection('Bookings')
          .doc(event.bookingId)
          .get();

      if (docSnapshot.exists) {
        final booking = docSnapshot.data()!;

        // Fetch worker details from the workers collection
        final workerDoc = await FirebaseFirestore.instance
            .collection('workers')
            .doc(booking['workerId'])
            .get();

        if (workerDoc.exists) {
          final workerData = workerDoc.data()!;
          booking['workerName'] = workerData['userName'];
          booking['workerCategory'] = workerData['category'];
        } else {
          booking['workerName'] = 'Unknown';
          booking['workerCategory'] = 'Unknown';
        }

        emit(BookingDetailLoadedState(booking));
      } else {
        emit(BookingDetailsError('Booking not found.'));
      }
    } catch (e) {
      emit(BookingDetailsError('Failed to fetch booking details.'));
    }
  }

  FutureOr<void> paymentSuccessRebuildEvent(
      PaymentSuccessRebuildEvent event, Emitter<BookingDetailsState> emit) {
    emit(PaymentSuccessRebuildState());
    print('bloc called');
  }
}
