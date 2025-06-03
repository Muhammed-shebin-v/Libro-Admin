import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BookModel {
  final String? uid;
  final String bookName;
  final String? bookId;
  final String authorName;
  final String? description;
  final String? category;
  final int? pages;
  final int? stocks;
  final String? location;
  final Color? color;
  final int? score;
  final DateTime date;
  final List<String>? imageUrls;
  final int? currentStock;
  final int? readers;

  BookModel({
    this.uid,
    this.score = 0,
    required this.date,
    required this.bookName,
     this.bookId,
    required this.authorName,
     this.description,
     this.category,
     this.pages,
     this.stocks,
     this.location,
     this.color,
    this.imageUrls,
    this.currentStock,
    this.readers,
    });

  factory BookModel.fromMap(Map<String,dynamic> data) {
    return BookModel(
      uid: data['uid']??'',
      bookName: data['bookName'] ?? '',
      bookId: data['bookId'] ?? '',
      authorName: data['authorName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      pages: data['pages'] ?? '',
      stocks: data['stocks'] ?? '',
      location: data['location'] ?? '',
      color: Color(data['color']),
      score: data['score'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls']) 
          : [],
          readers: data['readers']??0,
          currentStock: data['currentStock']??data['stocks']??0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookName': bookName,
      'bookId': bookId,
      'authorName': authorName,
      'description': description,
      'category': category,
      'pages': pages,
      'stocks': stocks,
      'location': location,
      'date': DateTime.now(),
      'color': color!.toARGB32(),
      'imageUrls': imageUrls,
      'currentStock':currentStock
    };
  }
  BookModel copyWith({
  String? uid,
  String? bookName,
  String? bookId,
  String? authorName,
  String? description,
  String? category,
  int? pages,
  int? stocks,
  String? location,
  Color? color,
  int? score,
  DateTime? date,
  List<String>? imageUrls,
  int? currentStock,
  int? readers,
}) {
  return BookModel(
    uid: uid ?? this.uid,
    bookName: bookName ?? this.bookName,
    bookId: bookId ?? this.bookId,
    authorName: authorName ?? this.authorName,
    description: description ?? this.description,
    category: category ?? this.category,
    pages: pages ?? this.pages,
    stocks: stocks ?? this.stocks,
    location: location ?? this.location,
    color: color ?? this.color,
    score: score ?? this.score,
    date: date ?? this.date,
    imageUrls: imageUrls ?? this.imageUrls,
    currentStock: currentStock ?? this.currentStock,
    readers: readers ?? this.readers,
  );
}

}