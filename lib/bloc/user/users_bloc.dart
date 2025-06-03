import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/bloc/user/users_state.dart';
import 'package:libro_admin/models/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection(
    'users',
  );

  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SelectUser>(_onSelectUser);
    on<SearchUsers>(_onSearchUsers);
    on<SortChanged>(_sortchanged);
    on<LoadUsersAlphabetical>(_loadAlphabetical);
    on<LoadUsersLatest>(_loadLatest);
  }


  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final snapshot = await usersRef.get();
      final userList =
          snapshot.docs.map((e) => UserModel.fromMap(e.data() as Map<String,dynamic> )).toList();
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
              .map((doc) => UserModel.fromMap(doc.data() as Map<String,dynamic>)).toList()
              .where((user) {
                final username =(user.userName).toString().toLowerCase();
                final email = (user.email).toString().toLowerCase();
                final phone =(user.phoneNumber).toString().toLowerCase();
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
  Future<void> _loadAlphabetical(
    LoadUsersAlphabetical event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .orderBy('userName')
              .get();

      final books = snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      emit(UserLoaded(books));
    } catch (e) {
      emit(UserError('Failed to load books'));
    }
  }

  Future<void> _loadLatest(
    LoadUsersLatest event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .orderBy('createdAt', descending: true)
              .get();

      final books = snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      emit(UserLoaded(books));
    } catch (e) {
      emit(UserError('Failed to load books'));
    }
  }

  Future<void> _sortchanged(SortChanged event, Emitter<UserState> emit) async {
    emit(SortState(event.newSort));
    if (event.newSort == 'Alphabetical') {
      add(LoadUsersAlphabetical());
    } else if (event.newSort == 'Latest') {
      add(LoadUsersLatest());
    }
  }

}
