import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{
 final _fire=FirebaseFirestore.instance;

 create({required String bookname, required String bookId, required String authorName, required String description, required String category, required String pages, required String stocks, required String location}) {
  try{
    _fire.collection('books').add({'bookname':bookname,'bookid':bookId,'authername':authorName,'description':description,'category':category,'pages':pages,'stocks':stocks,'location':location});

  }catch(e){
    log(e.toString());
  }
 }
}