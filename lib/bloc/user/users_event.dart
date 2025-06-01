abstract class UserEvent {
  const UserEvent();
}

class FetchUsers extends UserEvent {}

class SelectUser extends UserEvent {
  final Map<String, dynamic> user;
  const SelectUser(this.user);
}

class SearchUsers extends UserEvent {
  final String query;
  SearchUsers(this.query);
}
class LoadUsersAlphabetical extends UserEvent {
  const LoadUsersAlphabetical();
}
class LoadUsersLatest extends UserEvent {
  const LoadUsersLatest();
}
class SortChanged extends UserEvent {
  final String newSort;
  SortChanged(this.newSort);
}