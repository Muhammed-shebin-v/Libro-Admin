

import 'package:libro_admin/models/book.dart';

abstract class BookEvent {
   const BookEvent();
}

class LoadBooks extends BookEvent {
  const LoadBooks();
}

class SelectBook extends BookEvent {
  final BookModel book;
  const SelectBook(this.book);
}

class DeleteBook extends BookEvent {
  final String uid;
  const DeleteBook(this.uid);
}

class EditBook extends BookEvent {
  final BookModel book;
  const EditBook(this.book);
}

class AddBook extends BookEvent {
  final BookModel book;
  AddBook(this.book);
}
class LoadBooksAlphabetical extends BookEvent {
  const LoadBooksAlphabetical();
}
class LoadBooksLatest extends BookEvent {
  const LoadBooksLatest();
}
class SortChanged extends BookEvent {
  final String newSort;
  SortChanged(this.newSort);
}
class PickImagesEvent extends BookEvent {}
class UploadBookEvent extends BookEvent {
  final String title;
  UploadBookEvent(this.title);
}
class LoadBooksByCategory extends BookEvent {
  final String categoryName;
  LoadBooksByCategory(this.categoryName);
}
class SearchBooks extends BookEvent {
  final String query;
  SearchBooks(this.query);
}
