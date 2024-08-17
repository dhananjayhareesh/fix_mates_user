part of 'booking_conformation_bloc.dart';

@immutable
sealed class BookingConformationState {}

final class BookingConformationInitial extends BookingConformationState {}

class BookingConformationLoading extends BookingConformationState {}

class BookingConformationLoaded extends BookingConformationState {
  final String locationName;

  BookingConformationLoaded(this.locationName);
}

class BookingConformationError extends BookingConformationState {
  final String error;

  BookingConformationError(this.error);
}
