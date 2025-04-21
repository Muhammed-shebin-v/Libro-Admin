abstract class BookEvent {}

class FetchBooks extends BookEvent {}

class SelectBook extends BookEvent {
  final Map<String, dynamic> book;
  SelectBook(this.book);
}
