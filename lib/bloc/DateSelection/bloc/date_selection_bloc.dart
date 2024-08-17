import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'date_selection_event.dart';
part 'date_selection_state.dart';

class DateSelectionBloc extends Bloc<DateSelectionEvent, DateSelectionState> {
  DateSelectionBloc() : super(DateSelectionInitial()) {
    on<SelectDateEvent>(_onSelectDateEvent);
    on<SelectTimeSlotEvent>(_onSelectTimeSlotEvent);
  }

  void _onSelectDateEvent(
      SelectDateEvent event, Emitter<DateSelectionState> emit) {
    emit(DateSelectionSelected(
      selectedDate: event.selectedDate,
      selectedTimeSlot: state is DateSelectionSelected
          ? (state as DateSelectionSelected).selectedTimeSlot
          : null,
    ));
  }

  void _onSelectTimeSlotEvent(
      SelectTimeSlotEvent event, Emitter<DateSelectionState> emit) {
    if (state is DateSelectionSelected) {
      final currentState = state as DateSelectionSelected;
      emit(DateSelectionSelected(
        selectedDate: currentState.selectedDate,
        selectedTimeSlot: event.selectedTimeSlot,
      ));
    }
  }
}
