import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/bloc/user/users_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SelectUser>(_onSelectUser);
  }
  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
  emit(UserLoading());
  try {
    final snapshot = await usersRef.get();
    final userList = snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    emit(UserLoaded(userList));
  } catch (e) {
    emit(UserError("Failed to fetch users: $e")); 
  }
}
void _onSelectUser (SelectUser  event, Emitter<UserState> emit) {
  if (state is UserLoaded) {
    final currentState = state as UserLoaded;
    emit(currentState.copyWith(selectedUser: event.user));
  }
}
}

