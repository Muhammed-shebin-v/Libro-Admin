abstract class UserEvent {}

class FetchUsers extends UserEvent {}

class SelectUser extends UserEvent {
  final Map<String, dynamic> user;
  SelectUser(this.user);
}
