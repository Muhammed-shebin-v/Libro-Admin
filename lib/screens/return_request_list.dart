import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro_admin/bloc/bloc/return_request_bloc.dart';
import 'package:libro_admin/bloc/bloc/return_request_event.dart';
import 'package:libro_admin/bloc/bloc/return_request_state.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/models/user.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/search_bar.dart';

class ReturnRequestList extends StatelessWidget {
  ReturnRequestList({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: BlocBuilder<ReturnRequestedBooksBloc, ReturnRequestState>(
        builder: (context, state) {
          if (state is ReturnRequestedBooksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReturnRequestedBooksError) {
            return Center(child: Text(state.message));
          } else if (state is ReturnRequestedBooksLoaded) {
            final items = state.list;
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSearchBar(
                        controller: controller,
                        onchanged: (query) {},
                      ),

                      Row(
                        children: [
                          const Text(
                            'Return Requests',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            // const SizedBox(width: 40),
                            Expanded(
                              child: Text(
                                'User',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Gap(40),
                            Expanded(
                              child: Text(
                                'Book',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Gap(40),
                            Expanded(
                              child: Text(
                                'Borrowed Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Return Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Fine',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Respond Button',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final book = items[index];
                            // bool isSelected =
                            //     state.selectedBook != null &&
                            //     state.selectedBook!['uid'] == book['uid'];
                            return InkWell(
                              onTap: () {
                                // context.read<BookBloc>().add(SelectBook(book));
                              },
                              child: Container(
                                color:
                                    // isSelected
                                    //     ? AppColors.color10
                                    //     : (index % 2 == 0
                                    //         ? Colors.white
                                    // :
                                    AppColors.color60,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),

                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                book.userImage,
                                              ),
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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

                                      Expanded(
                                        child: Text(book.fine.toString()),
                                      ),

                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    // book['color'] != null
                                                    //     ? Color(book['color'])
                                                    // :
                                                    AppColors.secondary,
                                                //  Colors.red
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
                                            showdialog1(context: context,borrowId:book.borrowId,userId: book.userId,bookId: book.bookId);
                                          },
                                          child: Text('Respond'),
                                          style: ButtonStyle(
                                            iconColor:WidgetStatePropertyAll(AppColors.color10),
                                            backgroundColor: WidgetStatePropertyAll(AppColors.color10),
                                            overlayColor: WidgetStatePropertyAll(AppColors.white),

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // BookDetailsWidget(book: state.selectedBook),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: AppColors.color30,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(10.0),
                ),
              ],
            );
          } else {
            return Center(child: Text('error'));
          }
        },
      ),
    );
  }
  void showdialog1({context,borrowId,userId,bookId}){
     showDialog(context: context, builder: (context)=>
     AlertDialog(
      
      title: Text('Return Request'),
      content: Text('username is requested to return bookname.\nwhile validation his data is fully ok with our privacy policy,\nthere is no more fine left...'),
      actions: [
        TextButton.icon(onPressed: (){}, label: Text('Decline'),icon: Icon(Icons.close,color: AppColors.secondary)),
        TextButton.icon(onPressed: (){
          updateBorrowStatus(borrowId: borrowId,bookId: borrowId,userId: userId);

          context.read<ReturnRequestedBooksBloc>().add(LoadReturnRequestedBooks());
          Navigator.pop(context);
        }, label: Text('Accept'),icon: Icon(Icons.check,color: AppColors.color60))
      ],
     ));
     
     
     
     
     
     
     
     
     
     
     
     
     
     
  }
  void updateBorrowStatus({borrowId,bookId,userId}) async {
    FirebaseFirestore.instance.collection('borrows').doc(borrowId).update({
      'status': 'returned',
    });
    final userDoc=await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData=UserModel.fromMap(userDoc.data() as Map<String,dynamic>);
    final newBorrowLimit=(userData.borrowLimit)+1;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'borrowLimit':newBorrowLimit
    });
    final bookDoc=await FirebaseFirestore.instance.collection('books').doc(bookId).get();
    final bookData=BookModel.fromMap(bookDoc.data()as Map<String,dynamic>);
    final newStock=(bookData.currentStock!)+1;
    FirebaseFirestore.instance.collection('books').doc(bookId).update({
      'currentStock':newStock
    });

  }
}
