import 'package:equatable/equatable.dart';

// abstract class UserState {}
abstract class UserState{
 const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic>? selectedUser;

   const UserLoaded(this.users, {this.selectedUser});

UserLoaded copyWith({
    List<Map<String, dynamic>>? users,
    Map<String, dynamic>? selectedUser,
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





