import 'package:libro_admin/models/user.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final UserModel? selectedUser;

  const UserLoaded(this.users, {this.selectedUser});

  UserLoaded copyWith({
    List<UserModel>? users,
    UserModel? selectedUser,
  }) {
    return UserLoaded(
      users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
class SortState extends UserState {
  final String selectedSort;
  SortState(this.selectedSort);
}
