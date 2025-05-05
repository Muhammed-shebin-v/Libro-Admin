import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/db/book.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final db=DataBaseService();

  BookBloc() : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SelectBook>(_onSelectBook);
    on<DeleteBook>(_onDeleteBook);
    on<EditBook>(_onEditBook);
    on<AddBook>(_onAddBook);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final bookList = await db.getBooks();
       emit(BookLoaded(bookList));
    } catch (e) {
      emit(BookError("Failed to fetch users: $e"));
    }
  }


  void _onSelectBook(SelectBook event, Emitter<BookState> emit) {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;
      emit(currentState.copyWith(selectedBook: event.book));
    }
  }

  Future<void> _onDeleteBook(DeleteBook event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      // final currentState = state as BookLoaded;
      emit(BookLoading());
      try {
        await db.delete(event.uid); // Assuming this deletes and returns nothing
        final books = await db.getBooks(); // Refresh the books
        emit(BookLoaded(books));
      } catch (e) {
        emit(BookError(e.toString())); 
      }
    }
  }

Future<void> _onAddBook(AddBook event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      emit(BookLoading());
      try {
        await db.create(event.book);
        final books = await db.getBooks();
        emit(BookLoaded(books));
      } catch (e) {
        emit(BookError("Failed to add book: $e"));
      }
    }
  }
  Future<void> _onEditBook(EditBook event, Emitter<BookState> emit) async {
    if (state is BookLoaded) {
      // final currentState = state as BookLoaded;
      emit(BookLoading());
      try {
        await db.updateBook(event.book); // Assuming this method exists
        final books = await db.getBooks(); // Refresh the books
        emit(BookLoaded(books, selectedBook: event.book));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    }
  }
}
 

