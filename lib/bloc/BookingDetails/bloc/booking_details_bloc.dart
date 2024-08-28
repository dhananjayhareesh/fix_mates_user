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
  }

  Future<void> _onFetchUserBookings(
      FetchUserBookings event, Emitter<BookingDetailsState> emit) async {
    try {
      emit(BookingDetailsLoading());

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Bookings')
          .where('userId', isEqualTo: event.userDocId)
          .get();

      final bookings = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'date': data['date'],
          'timeSlot': data['timeSlot'],
          'description': data['description'],
          'status': data['status'],
          'startTime': data['startTime'],
          'endTime': data['endTime'],
        };
      }).toList();

      emit(BookingDetailsLoaded(bookings));
    } catch (e) {
      emit(BookingDetailsError('Failed to fetch bookings.'));
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

        emit(BookingDetailLoaded(booking));
      } else {
        emit(BookingDetailsError('Booking not found.'));
      }
    } catch (e) {
      emit(BookingDetailsError('Failed to fetch booking details.'));
    }
  }
}
