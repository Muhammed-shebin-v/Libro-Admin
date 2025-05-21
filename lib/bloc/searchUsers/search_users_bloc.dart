import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/searchUsers/search_users_event.dart';
import 'package:libro_admin/bloc/searchUsers/search_users_state.dart';
import 'package:libro_admin/models/user.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  SearchUsersBloc() : super(SearchUsersInitial()) {
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onSearchUsers(event, emit) async {
    if (event.query.isEmpty) {
      emit(SearchUsersInitial());
      return;
    }

    emit(SearchUsersLoading());

    try {
      final query = event.query.toLowerCase();
      final booksSnap =
          await FirebaseFirestore.instance.collection('users').get();

      final results =
          booksSnap.docs
              .map((doc) {
                final data = doc.data();
                return User(
                  username: data['username'] ?? '',
                  fullName: data['fullName'] ?? '',
                  email: data['email'] ?? '',
                  phoneNumber: data['phoneNumber'] ?? '',
                  address: data['address'] ?? '',
                  imgeUrl: data['imgUrl'] ?? '',
                );
              })
              .where(
                (user) =>
                    user.fullName!.toLowerCase().contains(query) ||
                    user.email.toLowerCase().contains(query) ||
                    user.address.toLowerCase().contains(query) ||
                     user.phoneNumber.toLowerCase().contains(query) ||
                    user.username!.toLowerCase().contains(query),
              )
              .toList();

      emit(SearchUsersLoaded(results));
    } catch (e) {
      emit(SearchUsersError('Error searching books: $e'));
    }
  }
}
