import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/bloc/bloc/borrowed_user_bloc.dart';
import 'package:libro_admin/bloc/bloc/borrowed_user_event.dart';
import 'package:libro_admin/bloc/bloc/borrowed_user_state.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/bloc/reviews/review_bloc.dart';
import 'package:libro_admin/bloc/reviews/review_event.dart';
import 'package:libro_admin/bloc/reviews/review_state.dart';
import 'package:libro_admin/models/review_model.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/addpop.dart';
import 'package:libro_admin/widgets/borrowed_user.dart';
import 'package:libro_admin/widgets/rating_stars.dart';

class BookDetailsWidget extends StatelessWidget {
  const BookDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listenWhen:
          (prev, curr) =>
              curr is BookLoaded &&
              prev is BookLoaded &&
              curr.selectedBook?.uid != prev.selectedBook?.uid,
      listener: (context, state) {
        if (state is BookLoaded && state.selectedBook != null) {
          context.read<BookBorrowsBloc>().add(
            FetchBookBorrows(state.selectedBook!.uid!),
          );
          context.read<ReviewsBloc>().add(
            FetchReviews(state.selectedBook!.uid!),
          );
        }
      },
      child: SizedBox(
        width: 400,
        height: double.infinity,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.color30,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(),
          ),
          child: BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BookError) {
                return Center(child: Text(state.message));
              } else if (state is BookLoaded) {
                final book = state.selectedBook;
                if (book == null) {
                  return const Center(child: Text('Select a book'));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(book.bookId ?? ''),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              AddBookDialog(isUpdate: true,bookData: book,);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const Divider(),

                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child:
                                  book.imageUrls == null
                                      ? const Text('No images selected.')
                                      : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: book.imageUrls!.length,
                                        itemBuilder:
                                            (context, index) => Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  book.imageUrls![index],
                                                  fit: BoxFit.fill,
                                                  width: 120,
                                                  height: 140,
                                                ),
                                              ),
                                            ),
                                      ),
                            ),
                            const Gap(8),
                            Text(book.bookName, style: AppFonts.heading2),
                            Text(
                              book.authorName,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const Gap(16),

                      _buildStatsSection(book),

                      const Gap(16),

                      Text(
                        book.description ?? '',
                        style: const TextStyle(height: 1.5),
                      ),
                      const Gap(16),

                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const Gap(8),
                          Text(book.location ?? ''),
                        ],
                      ),
                      const Gap(16),

                      Text('Borrowed Users', style: AppFonts.heading3),
                      const Gap(8),
                      _buildBorrowedUsers(),

                      const Gap(20),

                      Text('Reviews', style: AppFonts.heading3),
                      _buildReviewsSection(),
                      const Gap(20),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(book) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '${book.stocks}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.star, color: AppColors.color10),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: book.currentStock! > 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(),
                    ),
                  ),
                  const Gap(5),
                  Text(book.currentStock! > 0 ? 'Available' : 'Out of stock'),
                ],
              ),
              Text('${book.pages} • ${book.category}'),
            ],
          ),
          Text('${book.readers} Readers'),
        ],
      ),
    );
  }

  Widget _buildBorrowedUsers() {
    return BlocBuilder<BookBorrowsBloc, BookBorrowsState>(
      builder: (context, state) {
        if (state is BookBorrowsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookBorrowsLoaded) {
          if (state.borrowedUsers.isEmpty) {
            return Center(
              child: Text('No borrow records found.', style: AppFonts.body1),
            );
          }
          return Column(
            children:
                state.borrowedUsers
                    .map((user) => Borroweduser(userInfo: user))
                    .toList(),
          );
        } else if (state is BookBorrowsError) {
          return Text(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReviewsSection() {
    return BlocBuilder<ReviewsBloc, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReviewsLoaded) {
          if (state.reviews.isEmpty) {
            return Center(child: Text('No reviews yet', style: AppFonts.body1));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.reviews.length,
            itemBuilder:
                (context, index) => _buildReviewItem(state.reviews[index]),
          );
        } else if (state is ReviewsError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.color60,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(),
        boxShadow: const [
          BoxShadow(offset: Offset(3, 3), color: AppColors.grey),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child:
                review.userImage.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(review.userImage),
                    )
                    : const Icon(Icons.person),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StarRating(rating: review.rating),
                  ],
                ),
                Text(
                  DateFormat(
                    'dd-MM-yyyy, hh:mm a',
                  ).format(DateTime.parse(review.date)),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Gap(4),
                Text(review.reviewText, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
