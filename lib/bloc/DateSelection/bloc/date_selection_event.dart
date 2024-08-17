part of 'date_selection_bloc.dart';

@immutable
abstract class DateSelectionEvent {}

class SelectDateEvent extends DateSelectionEvent {
  final DateTime selectedDate;

  SelectDateEvent(this.selectedDate);
}

class SelectTimeSlotEvent extends DateSelectionEvent {
  final String selectedTimeSlot;

  SelectTimeSlotEvent(this.selectedTimeSlot);
}
