// lib/features/presentation/bloc/reviews/review_event.dart
abstract class ReviewsEvent {}

class FetchReviews extends ReviewsEvent {
  final String bookId;
  FetchReviews(this.bookId);
}
