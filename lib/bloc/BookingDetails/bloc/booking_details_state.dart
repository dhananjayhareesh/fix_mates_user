part of 'booking_details_bloc.dart';

@immutable
abstract class BookingDetailsState {}

class BookingDetailsInitial extends BookingDetailsState {}

class BookingDetailsLoading extends BookingDetailsState {}

class BookingDetailsLoaded extends BookingDetailsState {
  final List<Map<String, dynamic>> bookings;

  BookingDetailsLoaded(this.bookings);
}

class BookingDetailLoaded extends BookingDetailsState {
  final Map<String, dynamic> booking;

  BookingDetailLoaded(this.booking);
}

class BookingDetailsError extends BookingDetailsState {
  final String message;

  BookingDetailsError(this.message);
}
