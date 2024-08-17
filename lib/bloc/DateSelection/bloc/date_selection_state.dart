part of 'date_selection_bloc.dart';

@immutable
abstract class DateSelectionState {}

class DateSelectionInitial extends DateSelectionState {}

class DateSelectionSelected extends DateSelectionState {
  final DateTime selectedDate;
  final String? selectedTimeSlot;

  DateSelectionSelected({
    required this.selectedDate,
    this.selectedTimeSlot,
  });
}
