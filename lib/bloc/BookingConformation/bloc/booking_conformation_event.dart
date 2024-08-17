part of 'booking_conformation_bloc.dart';

@immutable
sealed class BookingConformationEvent {}

class FetchLocationEvent extends BookingConformationEvent {}
