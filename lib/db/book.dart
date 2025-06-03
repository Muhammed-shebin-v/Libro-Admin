import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/models/book.dart';

final CollectionReference _fb = FirebaseFirestore.instance.collection('books');

class DataBaseService {
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
      DocumentReference docRef = await _fb.add(updatedBokk.toMap());
      await docRef.update({'uid': docRef.id});
      log('created new');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<BookModel>> getBooks() async {
    final snapshot = await _fb.get();
    final bookList =snapshot.docs.map((e) => BookModel.fromMap(e.data() as Map<String,dynamic>)).toList();
    return bookList;
  }

  Future<void> updateBook(BookModel book) async {
    try {
      await _fb.doc(book.uid).update(book.toMap()
        // {
        //   'bookName': book['bookName'],
        //   'bookId': book['bookId'],
        //   'authorName': book['authorName'],
        //   'description': book['description'],
        //   'category': book['category'],
        //   'pages': book['pages'],
        //   'stocks': book['stocks'],
        //   'location': book['location'],
        //   'imgUrl': book['imgUrl'],
        //   'date': DateTime.now(),
        //   'color': book['color'],
        // },
        // book.toMap(),
      );
       log('Updated book with ID: ${book.uid}');
    } catch (e) {
      log('Error updating book: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> delete(String uid) async {
    await _fb.doc(uid).delete();
  }
}
