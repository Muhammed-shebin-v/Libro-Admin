import 'package:libro_admin/models/borrowed_book.dart';

abstract class BorrowedBooksState {}
class BorrowedBooksInitial extends BorrowedBooksState {}
class BorrowedBooksLoading extends BorrowedBooksState {}
class BorrowedBooksLoaded extends BorrowedBooksState {
  final List<BorrowedBookModel> list;
  BorrowedBooksLoaded(this.list);
}
class BorrowedBooksError extends BorrowedBooksState {
  final String message;
  BorrowedBooksError(this.message);
}