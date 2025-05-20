class BorrowedBookModel {
  final String userName;
  final String userImage;
  final String bookName;
  final String bookImage;
  final DateTime borrowDate;
  final DateTime returnDate;
  final int fine;
  final String status;

  BorrowedBookModel({
    required this.userName,
    required this.userImage,
    required this.bookName,
    required this.bookImage,
    required this.borrowDate,
    required this.returnDate,
    required this.fine,
    required this.status,
  });
}
