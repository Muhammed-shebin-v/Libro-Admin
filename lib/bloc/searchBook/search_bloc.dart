import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro_admin/bloc/searchBook/search_event.dart';
import 'package:libro_admin/bloc/searchBook/search_state.dart';
import 'package:libro_admin/models/book.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchBooks>(_onSearchBooks);
  }

  Future<void> _onSearchBooks(event, emit) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final query = event.query.toLowerCase();
      final booksSnap =
          await FirebaseFirestore.instance.collection('books').get();

      final results =
          booksSnap.docs
              .map((doc) {
                final data = doc.data();

                return Book(
                  bookName: data['bookName'] ?? '',
                  authorName: data['authorName'] ?? '',
                  imageUrls:
                      data['imageUrls'] != null
                          ? List<String>.from(
                            (data['imageUrls'] as List).map(
                              (e) => e.toString(),
                            ),
                          )
                          : [],
                );
              })
              .where(
                (book) =>
                    book.bookName.toLowerCase().contains(query) ||
                    book.authorName.toLowerCase().contains(query),
              )
              .toList();

      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError('Error searching books: $e'));
    }
  }
}
