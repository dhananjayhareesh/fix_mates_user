part of 'booking_details_bloc.dart';

@immutable
abstract class BookingDetailsEvent {}

class FetchUserBookings extends BookingDetailsEvent {
  final String userDocId;

  FetchUserBookings(this.userDocId);
}

class FetchBookingDetail extends BookingDetailsEvent {
  final String bookingId;

  FetchBookingDetail(this.bookingId);
}

class PaymentSuccessRebuildEvent extends BookingDetailsEvent {}
