abstract class SearchEvent {}
class SearchBooks extends SearchEvent {
  final String query;
  SearchBooks(this.query);
}