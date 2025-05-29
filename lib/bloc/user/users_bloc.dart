import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/bloc/user/users_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection(
    'users',
  );

  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SelectUser>(_onSelectUser);
    on<SearchUsers>(_onSearchUsers);
  }


  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final snapshot = await usersRef.get();
      final userList =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      emit(UserLoaded(userList));
    } catch (e) {
      emit(UserError("Failed to fetch users: $e"));
    }
  }

  void _onSelectUser(SelectUser event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      emit(currentState.copyWith(selectedUser: event.user));
    }
  }



  Future<void> _onSearchUsers(event, emit) async {
    if (event.query.isEmpty) {
      return _onFetchUsers(FetchUsers(), emit);
    }
    emit(UserLoading());
    try {
      final query = event.query.toLowerCase();
      final usersSnap = await usersRef.get();
      final results =
          usersSnap.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList()
              .where((user) {
                final username =(user['username'] ?? '').toString().toLowerCase();
                final email = (user['email'] ?? '').toString().toLowerCase();
                final phone =(user['phoneNumber'] ?? '').toString().toLowerCase();
                return username.contains(query) ||
                    email.contains(query) ||
                    phone.contains(query);
              })
              .toList();
      emit(UserLoaded(results));
    } catch (e) {
      emit(UserError('Error searching books: $e'));
    }
  }
}
