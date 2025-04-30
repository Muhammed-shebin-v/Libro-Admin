class Book {
  final String bookName;
  final String bookId;
  final String authorName;
  final String description;
  final String category;
  final String pages;
  final String stocks;
  final String location;
  final String imgUrl;

  Book({
    required this.bookName,
    required this.bookId,
    required this.authorName,
    required this.description,
    required this.category,
    required this.pages,
    required this.stocks,
    required this.location,
    required this.imgUrl
  });

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(
      bookName: data['bookname'] ?? '',
      bookId: data['bookId'] ?? '',
      authorName: data['authorName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      pages: data['pages'] ?? 0,
      stocks: data['stocks'] ?? 0,
      location: data['location'] ?? '',
      imgUrl: data['imgUrl']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookname': bookName,
      'bookId': bookId,
      'authorName': authorName,
      'description': description,
      'category': category,
      'pages': pages,
      'stocks': stocks,
      'location': location,
      'imgUrl':imgUrl
    };
  }
}