class SearchState {
  final String query;

  SearchState({required this.query});

  factory SearchState.initial() => SearchState(query: '');

  SearchState copyWith({String? query}) {
    return SearchState(query: query ?? this.query);
  }
}
