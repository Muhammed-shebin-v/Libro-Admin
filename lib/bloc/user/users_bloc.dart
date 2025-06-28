import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/bloc/user/users_state.dart';
import 'package:libro_admin/db/user.dart';
import 'package:libro_admin/models/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CollectionReference usersRef = FirebaseFirestore.instance.collection(
    'users',
  );
  final _userService=UserService();

  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SelectUser>(_onSelectUser);
    on<SearchUsers>(_onSearchUsers);
    on<SortChanged>(_sortchanged);
    on<LoadUsersAlphabetical>(_loadUsersAlphabetical);
    on<LoadUsersAlphabeticalDesc>(_loadUsersAlphabeticalDesc);
    on<LoadUsersLatest>(_loadUsersLatest);
    on<LoadUsersOldest>(_loadUsersOldest);
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
   Future<void> _loadUsersAlphabetical(
      LoadUsersAlphabetical event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await _userService.fetchUsersAlphabetically();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to load users: $e'));
    }
  }

  Future<void> _loadUsersAlphabeticalDesc(
      LoadUsersAlphabeticalDesc event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await _userService.fetchUsersAlphabeticallyDesc();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to load users: $e'));
    }
  }

  Future<void> _loadUsersLatest(
      LoadUsersLatest event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await _userService.fetchLatestUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to load users: $e'));
    }
  }

  Future<void> _loadUsersOldest(
      LoadUsersOldest event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await _userService.fetchOldestUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Failed to load users: $e'));
    }
  }



  Future<void> _sortchanged(
    SortChanged event,
    Emitter<UserState> emit,
  ) async {
    emit(SortState(event.newSort));

    switch (event.newSort) {
      case 'Alphabetical ↑':
        add(LoadUsersAlphabetical());
        break;
      case 'Alphabetical ↓':
        add(LoadUsersAlphabeticalDesc());
        break;
      case 'Latest':
        add(LoadUsersLatest());
        break;
      case 'Oldest':
        add(LoadUsersOldest());
        break;
    }
  }

}
