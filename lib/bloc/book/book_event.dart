abstract class BookEvent {
   const BookEvent();
}

class LoadBooks extends BookEvent {
  const LoadBooks();
}

class SelectBook extends BookEvent {
  final Map<String, dynamic> book;
  const SelectBook(this.book);
}

class DeleteBook extends BookEvent {
  final String uid;
  const DeleteBook(this.uid);
}

class EditBook extends BookEvent {
  final Map<String, dynamic> book;
  const EditBook(this.book);
}