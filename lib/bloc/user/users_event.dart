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
