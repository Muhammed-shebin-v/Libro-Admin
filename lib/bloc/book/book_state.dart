import 'package:libro_admin/models/book.dart';

abstract class BookState {
    const BookState();
}

class BookInitial extends BookState {}

class BookLoading extends BookState {
  const BookLoading();
}

class BookLoaded extends BookState {
  final List<Map<String, dynamic>> books;
  final Map<String, dynamic>? selectedBook;
  
  const BookLoaded(this.books, {this.selectedBook});
  
  BookLoaded copyWith({
    List<Map<String, dynamic>>? books,
    Map<String, dynamic>? selectedBook,
  }) {
    return BookLoaded(
      books ?? this.books,
      selectedBook: selectedBook ?? this.selectedBook,
    );
  }
}

class BookError extends BookState {
  final String message;
  const BookError(this.message);
}
class BookAdded extends BookState {
  final Book book;
  const BookAdded(this.book);
}
class SortState extends BookState {
  final String selectedSort;
  SortState(this.selectedSort);
}
class BookUploaded extends BookState {}