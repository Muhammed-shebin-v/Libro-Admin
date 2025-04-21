abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Map<String, dynamic>> books;
  final Map<String, dynamic>? selectedBook;

  BookLoaded(this.books, {this.selectedBook});
}

class BookError extends BookState {
  final String message;
  BookError(this.message);
}
