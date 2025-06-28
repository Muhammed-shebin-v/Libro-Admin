import 'package:libro_admin/models/user.dart';

abstract class UserEvent {
  const UserEvent();
}

class FetchUsers extends UserEvent {}

class SelectUser extends UserEvent {
  final UserModel user;
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


class LoadUsersAlphabeticalDesc extends UserEvent {
  const LoadUsersAlphabeticalDesc();
}

class LoadUsersOldest extends UserEvent {
  const LoadUsersOldest();
}

class SortChanged extends UserEvent {
  final String newSort;
  SortChanged(this.newSort);
}