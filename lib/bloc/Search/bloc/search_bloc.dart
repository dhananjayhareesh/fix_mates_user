import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState.initial()) {
    on<UpdateSearchQuery>((event, emit) {
      emit(state.copyWith(query: event.query));
    });
  }
}
