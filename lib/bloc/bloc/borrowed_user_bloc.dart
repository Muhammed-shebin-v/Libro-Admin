import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/bloc/borrowed_user_event.dart';
import 'package:libro_admin/bloc/bloc/borrowed_user_state.dart';
import 'package:libro_admin/db/borrowed_user.dart';

class BookBorrowsBloc extends Bloc<BookBorrowsEvent, BookBorrowsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BookBorrowsBloc() : super(BookBorrowsInitial()) {
    on<FetchBookBorrows>(_onFetchBookBorrows);
  }

  Future<void> _onFetchBookBorrows(
    FetchBookBorrows event,
    Emitter<BookBorrowsState> emit,
  ) async {
    emit(BookBorrowsLoading());

    try {
      final bookId = event.bookId;

      // Step 1: Fetch borrowIds from books/{bookId}/borrows
      final borrowRefs = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('borrows')
          .get();

      List<BorrowedUserInfo> borrowedList = [];

      for (var doc in borrowRefs.docs) {
        final borrowId = doc.id;

        // Step 2: Get borrow info from borrows/{borrowId}
        final borrowSnap =
            await _firestore.collection('borrows').doc(borrowId).get();
        if (!borrowSnap.exists) continue;

        final borrowData = borrowSnap.data()!;
        final userId = borrowData['userId'];
        final borrowDate = (borrowData['borrowDate'] as Timestamp).toDate();
        final returnDate = (borrowData['returnDate'] as Timestamp).toDate();
        final status= (borrowData['status']);
        final fine= (borrowData['fine']);

        // Step 3: Get user info
        final userSnap =
            await _firestore.collection('users').doc(userId).get();
        if (!userSnap.exists) continue;

        final userData = userSnap.data()!;
        final userName = userData['userName'] ?? 'Unknown';
        final userEmail = userData['email'] ?? 'N/A';
        final imgUrl =userData['imgUrl'];

        borrowedList.add(
          BorrowedUserInfo(
            borrowId: borrowId,
            bookId: bookId,
            userId: userId,
            borrowDate: borrowDate,
            returnDate: returnDate,
            userName: userName,
            userEmail: userEmail,
            status: status,
            imgUrl: imgUrl,
            fine: fine
          ),
        );
      }

      emit(BookBorrowsLoaded(borrowedList));
    } catch (e) {
      emit(BookBorrowsError('Failed to fetch borrow users: $e'));
    }
  }
}
