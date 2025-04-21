import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/models/book.dart';

class DataBaseService {
  final _fire = FirebaseFirestore.instance;

  Future<void> create(Book book)async {
    try {
       DocumentReference docRef = await _fire.collection('books').add({
        'bookname': book.bookName,
        'bookid': book.bookId,
        'authername': book.authorName,
        'description': book.description,
        'category': book.category,
        'pages': book.pages,
        'stocks': book.stocks,
        'location': book.location,
      });
       await docRef.update({'uid': docRef.id});
      log('created new');
    } catch (e) {
      log(e.toString());
    }
  }
   Future<void> delete(String bookId,context) async {
    try {
      await _fire.collection('books').doc(bookId).delete();
      log('Book with ID $bookId deleted successfully.');
      context.read<BookBloc>().add(FetchBooks());
    } catch (e) {
      log('Error deleting book: $e');
    }
  }
}

