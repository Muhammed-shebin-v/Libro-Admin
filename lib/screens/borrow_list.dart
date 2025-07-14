import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/bloc/borrowedBooks/borrowed_books_dart_bloc.dart';
import 'package:libro_admin/bloc/borrowedBooks/borrowed_books_dart_state.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/search_bar.dart';

class AdminBorrowedBooksScreen extends StatelessWidget {
  AdminBorrowedBooksScreen({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: BlocBuilder<BorrowedBooksBloc, BorrowedBooksState>(
        builder: (context, state) {
          if (state is BorrowedBooksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BorrowedBooksError) {
            return Center(child: Text(state.message));
          } else if (state is BorrowedBooksLoaded) {
            final items = state.list;
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Books details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Gap(40),
                            Expanded(
                              child: Text('Book', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Gap(40),
                            Expanded(
                              child: Text('Borrowed Date', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('Return Date', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('Fine', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final book = items[index];
                            return Container(
                              color: AppColors.color60,
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade200,
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                          image: NetworkImage(book.userImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Text(book.userName)),
                                  Container(
                                    width: 40,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: NetworkImage(book.bookImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Text(book.bookName)),
                                  Expanded(
                                    child: Text(
                                      "📆 ${DateFormat('dd-MM-yyyy').format(DateTime.parse(book.borrowDate.toString()))}",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "📆 ${DateFormat('dd-MM-yyyy').format(DateTime.parse(book.returnDate.toString()))}",
                                    ),
                                  ),
                                  Expanded(child: Text('₹ ${book.fine.toString()}')),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(book.status),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   width: 400,
                //   decoration: BoxDecoration(
                //     color: AppColors.color30,
                //     borderRadius: BorderRadius.circular(20),
                //     border: Border.all(),
                //   ),
                //   padding: const EdgeInsets.all(10.0),
                //   margin: const EdgeInsets.all(10.0),
                // )
              ],
            );
          } else {
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
