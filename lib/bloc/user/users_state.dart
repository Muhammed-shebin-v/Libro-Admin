abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic>? selectedUser;

  UserLoaded(this.users, {this.selectedUser});
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
