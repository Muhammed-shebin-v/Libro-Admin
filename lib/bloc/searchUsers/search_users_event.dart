abstract class SearchUsersEvent {}
class SearchUsers extends SearchUsersEvent {
  final String query;
  SearchUsers(this.query);
}