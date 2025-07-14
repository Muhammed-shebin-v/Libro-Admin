import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/return/return_request_event.dart';
import 'package:libro_admin/bloc/return/return_request_state.dart';
import 'package:libro_admin/models/borrowed_book.dart';

class ReturnRequestedBooksBloc extends Bloc<ReturnRequestEvent, ReturnRequestState> {
  ReturnRequestedBooksBloc() : super(ReturnRequestedBooksInitial()) {
    on<LoadReturnRequestedBooks>((event, emit) async {
      emit(ReturnRequestedBooksLoading());
      try {
        final borrowSnapshots = await FirebaseFirestore.instance
    .collection('borrows')
    .where('status',whereIn: ['requested', 'payed'])
    .get();


        List<BorrowedBookModel> borrowDetails = [];

        for (var doc in borrowSnapshots.docs) {
         final borrowId=doc.id;
         log(borrowId);
          final userSnap =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(doc.data()['userId'])
                  .get();
          final bookSnap =
              await FirebaseFirestore.instance
                  .collection('books')
                  .doc(doc.data()['bookId'])
                  .get();

          final user = userSnap.data();
          final book = bookSnap.data();

          if (user != null && book != null) {
            borrowDetails.add(
              BorrowedBookModel(
                userId: user['uid'],
                userName: user['userName'] ?? '',
                userImage: user['imgUrl'] ?? '',
                bookId:  book['uid'],
                bookName: book['bookName'] ?? '',
                bookImage: book['imageUrls'][0] ?? '',
                // borrowId: doc.data()['uid'],
                borrowId:  borrowId,
                borrowDate:(doc.data()['borrowDate'] as Timestamp).toDate(),
                returnDate: (doc.data()['returnDate'] as Timestamp).toDate(),
                fine: doc.data()['fine'] ?? 0,
                status: doc.data()['status'] ?? 'ongoing',
              ),
            );
          }
        }
        emit(ReturnRequestedBooksLoaded(borrowDetails));
      } catch (e) {
        emit(ReturnRequestedBooksError('Failed to load borrowed books: $e'));
      }
    });
  }
}
