// lib/features/presentation/bloc/reviews/review_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/db/book.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final BookService _service = BookService();
  ReviewsBloc() : super(ReviewsInitial()) {
    on<FetchReviews>(_onFetchReviews);
  }

  Future<void> _onFetchReviews(FetchReviews event, Emitter<ReviewsState> emit) async {
    emit(ReviewsLoading());
    try {
      final reviews = await _service.fetchReviews(event.bookId);
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewsError("Failed to load reviews"));
    }
  }
}
