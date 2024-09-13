abstract class SearchEvent {}

class UpdateSearchQuery extends SearchEvent {
  final String query;

  UpdateSearchQuery(this.query);
}
