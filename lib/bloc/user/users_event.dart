abstract class UserEvent {
  const UserEvent();
}

class FetchUsers extends UserEvent {}

class SelectUser extends UserEvent {
  final Map<String, dynamic> user;
  const SelectUser(this.user);
}
