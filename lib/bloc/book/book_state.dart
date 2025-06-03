import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/models/book.dart';

abstract class BookState {
    const BookState();
}

class BookInitial extends BookState {}

class BookLoading extends BookState {
  const BookLoading();
}

class BookLoaded extends BookState {
  final List<BookModel> books;
  final BookModel? selectedBook;
  
  const BookLoaded(this.books, {this.selectedBook});
  
  BookLoaded copyWith({
    List<BookModel>? books,
    BookModel? selectedBook,
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
  final BookModel book;
  const BookAdded(this.book);
}
class SortState extends BookState {
  final String selectedSort;
  SortState(this.selectedSort);
}
class BookImagesSelected extends BookState {
  final List<String> images;
  BookImagesSelected(this.images);
}
