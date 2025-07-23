import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/bloc/return/return_request_bloc.dart';
import 'package:libro_admin/bloc/return/return_request_event.dart';
import 'package:libro_admin/bloc/return/return_request_state.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/models/user.dart';
import 'package:libro_admin/themes/fonts.dart';

class ReturnRequestList extends StatelessWidget {
  ReturnRequestList({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Row(
                  children: const [
                    Text(
                      'Return Requests',
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
                      Expanded(child: Text('User', style: TextStyle(fontWeight: FontWeight.bold))),
                      Gap(40),
                      Expanded(child: Text('Book', style: TextStyle(fontWeight: FontWeight.bold))),
                      Gap(40),
                      Expanded(child: Text('Borrowed Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Return Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Fine', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Respond Button', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ReturnRequestedBooksBloc, ReturnRequestState>(
                    builder: (context, state) {
                      if (state is ReturnRequestedBooksLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ReturnRequestedBooksError) {
                        return Center(child: Text(state.message));
                      } else if (state is ReturnRequestedBooksLoaded && state.list.isNotEmpty) {
                        final items = state.list;
                        return ListView.builder(
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
                                      "📆 ${DateFormat('d MMM yyyy').format(DateTime.parse(book.borrowDate.toString()))}",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "📆 ${DateFormat('d MMM yyyy').format(DateTime.parse(book.returnDate.toString()))}",
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
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showRespondDialog(
                                          context: context,
                                          borrowId: book.borrowId,
                                          userId: book.userId,
                                          bookId: book.bookId,
                                        );
                                      },
                                      style: ButtonStyle(
                                        iconColor: WidgetStatePropertyAll(AppColors.color10),
                                        backgroundColor: WidgetStatePropertyAll(AppColors.color10),
                                        overlayColor: WidgetStatePropertyAll(AppColors.white),
                                      ),
                                      child: const Text('Respond'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No Return requests'));
                      }
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
          // ),
        ],
      ),
    );
  }

  void showRespondDialog({context, borrowId, userId, bookId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Request'),
        content: const Text(
          'username is requested to return bookname.\nwhile validation his data is fully ok with our privacy policy,\nthere is no more fine left...',
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: const Text('Decline'),
            icon: Icon(Icons.close, color: AppColors.secondary),
          ),
          TextButton.icon(
            onPressed: () async {
              await updateBorrowStatus(
                borrowId: borrowId,
                userId: userId,
                bookId: bookId,
              );
              context.read<ReturnRequestedBooksBloc>().add(LoadReturnRequestedBooks());
              Navigator.pop(context);
            },
            label: const Text('Accept'),
            icon: Icon(Icons.check, color: AppColors.color60),
          ),
        ],
      ),
    );
  }

  Future<void> updateBorrowStatus({borrowId, bookId, userId}) async {
    await FirebaseFirestore.instance.collection('borrows').doc(borrowId).update({
      'status': 'returned',
    });

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    final newBorrowLimit = userData.borrowLimit + 1;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'borrowLimit': newBorrowLimit,
    });

    final bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();
    final bookData = BookModel.fromMap(bookDoc.data() as Map<String, dynamic>);
    final newStock = bookData.currentStock! + 1;

    await FirebaseFirestore.instance.collection('books').doc(bookId).update({
      'currentStock': newStock,
    });
  }
}
