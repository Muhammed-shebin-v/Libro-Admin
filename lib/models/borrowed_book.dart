class BorrowedBookModel {
  final String userId;
  final String userName;
  final String userImage;
  final String bookId;
  final String bookName;
  final String bookImage;
  final String borrowId;
  final DateTime borrowDate;
  final DateTime returnDate;
  final int fine;
  final String status;

  BorrowedBookModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.bookId,
    required this.bookName,
    required this.borrowId,
    required this.bookImage,
    required this.borrowDate,
    required this.returnDate,
    required this.fine,
    required this.status,
  });
}
