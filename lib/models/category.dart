import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;
  final Color color;
  final String location;
  final int totalBooks;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
    required this.location,
    required this.totalBooks,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      color: Color(int.tryParse(data['color'] ?? '0xff2196f3') ??0xff2196f3),
      location: data['location'] ?? '',
      totalBooks: data['totalBooks'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'color': '0x${color.value.toRadixString(16).padLeft(8, '0')}',
      'location': location,
      'totalBooks': totalBooks,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? imageUrl,
    Color? color,
    String? location,
    int? totalBooks,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      location: location ?? this.location,
      totalBooks: totalBooks ?? this.totalBooks,
    );
  }
}

