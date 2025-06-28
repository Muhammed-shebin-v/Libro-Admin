import 'package:libro_admin/models/borrowed_book.dart';

abstract class ReturnRequestState {}
class ReturnRequestedBooksInitial extends ReturnRequestState {}
class ReturnRequestedBooksLoading extends ReturnRequestState {}
class ReturnRequestedBooksLoaded extends ReturnRequestState {
  final List<BorrowedBookModel> list;
  ReturnRequestedBooksLoaded(this.list);
}
class ReturnRequestedBooksError extends ReturnRequestState {
  final String message;
  ReturnRequestedBooksError(this.message);
}