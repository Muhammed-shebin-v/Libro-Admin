abstract class BookBorrowsEvent {}

class FetchBookBorrows extends BookBorrowsEvent {
  final String bookId;

  FetchBookBorrows(this.bookId);
}
