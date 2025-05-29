import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/borrowedBooks/borrowed_books_dart_event.dart';
import 'package:libro_admin/bloc/borrowedBooks/borrowed_books_dart_state.dart';
import 'package:libro_admin/models/borrowed_book.dart';

class BorrowedBooksBloc extends Bloc<BorrowedBooksEvent, BorrowedBooksState> {
  BorrowedBooksBloc() : super(BorrowedBooksInitial()) {
    on<LoadBorrowedBooks>((event, emit) async {
      emit(BorrowedBooksLoading());
      try {
        final borrowSnapshots = await FirebaseFirestore.instance.collection('borrows').get();

        List<BorrowedBookModel> borrowDetails = [];

        for (var doc in borrowSnapshots.docs) {
         
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
                userName: user['fullName'] ?? '',
                userImage: user['imgUrl'] ?? '',
                bookName: book['bookName'] ?? '',
                bookImage: book['imageUrls'][0] ?? '',
                borrowDate: DateTime.parse(doc.data()['borrowDate']),
                returnDate: DateTime.parse(doc.data()['returnDate']),
                fine: doc.data()['fine'] ?? 0,
                status: doc.data()['status'] ?? 'ongoing',
              ),
            );
          }
        }
        emit(BorrowedBooksLoaded(borrowDetails));
      } catch (e) {
        emit(BorrowedBooksError('Failed to load borrowed books: $e'));
      }
    });
  }
}
