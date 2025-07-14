import 'package:libro_admin/db/borrowed_user.dart';

abstract class BookBorrowsState {}

class BookBorrowsInitial extends BookBorrowsState {}

class BookBorrowsLoading extends BookBorrowsState {}

class BookBorrowsLoaded extends BookBorrowsState {
  final List<BorrowedUserInfo> borrowedUsers;

  BookBorrowsLoaded(this.borrowedUsers);
}

class BookBorrowsError extends BookBorrowsState {
  final String message;
  BookBorrowsError(this.message);
}
