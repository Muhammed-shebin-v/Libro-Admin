import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/models/review_model.dart';


class BookService {
final CollectionReference _firebase = FirebaseFirestore.instance.collection(
  'books',
);
  Future<bool> create(BookModel book, List<String> imageUrls) async {
    try {
      final updatedBokk = BookModel(
        bookName: book.bookName,
        bookId: book.bookId,
        authorName: book.authorName,
        description: book.description,
        category: book.category,
        pages: book.pages,
        stocks: book.stocks,
        location: book.location,
        color: book.color,
        imageUrls: imageUrls,
        currentStock: book.stocks,
        date: book.date,
      );
      DocumentReference docRef = await _firebase.add(updatedBokk.toMap());
      await docRef.update({'uid': docRef.id});
      log('created new');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<BookModel>> getBooks() async {
    final snapshot = await _firebase.get();
    return snapshot.docs.map((e) => BookModel.fromMap(e.data() as Map<String, dynamic>)).toList();

  }

  Future<void> updateBook(BookModel book) async {
    try {
      await _firebase.doc(book.uid).update(book.toMap());
      log('Updated book with ID: ${book.uid}');
    } catch (e) {
      log('Error updating book: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> delete(String uid) async {
    await _firebase.doc(uid).delete();
  }

Future<List<BookModel>> fetchBooksAlphabetically() async {
  try {
    final snapshot = await _firebase.orderBy('bookName').get();

    return snapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String,dynamic>))
        .toList();
  } catch (e, stackTrace) {
    log('BookService.fetchBooksAlphabetically error: $e', stackTrace: stackTrace);
    rethrow;
  }
}
Future<List<BookModel>> fetchBooksAlphabeticallyDesc() async {
  try {
    final snapshot = await _firebase
        .orderBy('bookName', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e, stackTrace) {
    log('BookService.fetchBooksAlphabeticallyDesc error: $e', stackTrace: stackTrace);
    rethrow;
  }
}


Future<List<BookModel>> fetchLatestBooks() async {
  try {
    final snapshot = await _firebase
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String,dynamic>))
        .toList();
  } catch (e, stackTrace) {
    log('BookService.fetchLatestBooks error: $e', stackTrace: stackTrace);
    rethrow;
  }
}
Future<List<BookModel>> fetchOldestBooks() async {
  try {
    final snapshot = await _firebase
        .orderBy('date')
        .get();

    return snapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e, stackTrace) {
    log('BookService.fetchOldestBooks error: $e', stackTrace: stackTrace);
    rethrow;
  }
}
Future<List<ReviewModel>> fetchReviews(String bookId) async {
    try {
      log(bookId);
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .doc(bookId)
              .collection('reviews')
              .get();
      log("Number of reviews: ${snapshot.docs.length}");
      final reviews =
          snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data())).toList();
      return reviews;
    } catch (e) {
      log('error in loading reviews :$e');
      rethrow;
    }
  }

  Future<List<BookModel>> filterBooksByCategory(String category) async {
    try {
      final snapshot =
          await _firebase.where('category', isEqualTo: category).get();

      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data() as Map<String,dynamic>)).toList();
    } catch (e, stackTrace) {
      log(
        'SearchService.filterBooksByCategory error: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

}
