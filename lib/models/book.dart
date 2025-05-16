import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? uid;
  final String bookName;
  final String bookId;
  final String authorName;
  final String description;
  final String category;
  final String pages;
  final String stocks;
  final String location;
  final String imgUrl;
  final String color;
  final int score;
  final String date;

  Book({
    this.uid,
    this.score = 0,
    this.date = '',
    required this.bookName,
    required this.bookId,
    required this.authorName,
    required this.description,
    required this.category,
    required this.pages,
    required this.stocks,
    required this.location,
    required this.imgUrl,
    required this.color
    
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
      imgUrl: data['imgUrl']??'',
      color:(data['color'] ?? '0xff2196f3') ??0xff2196f3,
      score: data['score'] ?? 0,
      date: data['date']?.toDate().toString() ?? '',
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
      'imgUrl':imgUrl,
      'date': DateTime.now(),
      'color': color,
    };
  }
}