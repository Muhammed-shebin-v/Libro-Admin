import 'package:libro_admin/models/user.dart';
abstract class SearchUsersState {}
class SearchUsersInitial extends SearchUsersState {}
class SearchUsersLoading extends SearchUsersState {}
class SearchUsersLoaded extends SearchUsersState {
  final List<User> results;
  SearchUsersLoaded(this.results);
}
class SearchUsersError extends SearchUsersState {
  final String message;
  SearchUsersError(this.message);
}