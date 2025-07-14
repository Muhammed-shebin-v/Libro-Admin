import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/models/borrowed_book.dart';
import 'package:libro_admin/models/user.dart';

// class BorrowService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<BorrowModel> getBorrowById(String borrowId) async {
//     final doc = await _firestore.collection('borrows').doc(borrowId).get();
//     return BorrowModel.fromMap(doc.data()!, doc.id);
//   }

//   Future<UserModel> getUserById(String userId) async {
//     final doc = await _firestore.collection('users').doc(userId).get();
//     return UserModel.fromMap(doc.data()!);
//   }
// }
class BorrowedUserInfo {
  final String borrowId;
  final String bookId;
  final String userId;
  final DateTime borrowDate;
  final DateTime returnDate;
  final String userName;
  final String userEmail;
  final String status;
  final String imgUrl;
  final int fine;

  BorrowedUserInfo({
    required this.borrowId,
    required this.bookId,
    required this.userId,
    required this.borrowDate,
    required this.returnDate,
    required this.userName,
    required this.userEmail,
    required this.status,
    required this.imgUrl,
    required this.fine
  });
}

