import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/bloc/users_event.dart';
import 'package:libro_admin/bloc/bloc/users_state.dart';

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
  if (state is UserLoaded && event.user != null) {
    final current = state as UserLoaded;
    emit(UserLoaded(current.users, selectedUser : event.user));
  }
}
}
