class Book {
  final String bookName;
  final String bookId;
  final String authorName;
  final String description;
  final String category;
  final String pages;
  final String stocks;
  final String location;

  Book({
    required this.bookName,
    required this.bookId,
    required this.authorName,
    required this.description,
    required this.category,
    required this.pages,
    required this.stocks,
    required this.location,
  });

  // Factory method to create a Book object from a map
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
    );
  }

  // Method to convert a Book object to a map
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
    };
  }
}