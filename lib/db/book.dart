import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/models/book.dart';
 final CollectionReference _fb = FirebaseFirestore.instance.collection('books');

class DataBaseService {

  Future<bool> create(Book book) async {
    try {
      DocumentReference docRef = await _fb
          .add({
            'bookname': book.bookName,
            'bookid': book.bookId,
            'authername': book.authorName,
            'description': book.description,
            'category': book.category,
            'pages': book.pages,
            'stocks': book.stocks,
            'location': book.location,
            'imgUrl': book.imgUrl,
          });
      await docRef.update({'uid': docRef.id});
      log('created new');
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final snapshot=await _fb.get();
    final bookList =  snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    return List<Map<String, dynamic>>.from(
      bookList.map((item) => Map<String, dynamic>.from(item)),
    );
  }



  Future<void> updateBook(Map<String, dynamic> book) async {
    await _fb
        .doc(book['uid'])
        .update(book);
  }

  Future<void> delete(String uid) async {
    await _fb.doc(uid).delete();
  }


}
