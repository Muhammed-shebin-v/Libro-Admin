import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Book {
  final String? uid;
  final String bookName;
  final String? bookId;
  final String authorName;
  final String? description;
  final String? category;
  final String? pages;
  final String? stocks;
  final String? location;
  final Color? color;
  final int? score;
  final String? date;
  final List<String>? imageUrls;

  Book({
    this.uid,
    this.score = 0,
    this.date = '',
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
    });

  factory Book.fromMap(DocumentSnapshot doc) {
    final data =doc.data () as Map<String, dynamic>;
    return Book(
      uid: doc.id,
      bookName: data['bookname'] ?? '',
      bookId: data['bookId'] ?? '',
      authorName: data['authorName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      pages: data['pages'] ?? '',
      stocks: data['stocks'] ?? '',
      location: data['location'] ?? '',
      color: Color(int.parse(data['color'], radix: 16)),
      score: data['score'] ?? 0,
      date: data['date']?.toDate().toString() ?? '',
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls']) 
          : [],
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
    };
  }
}