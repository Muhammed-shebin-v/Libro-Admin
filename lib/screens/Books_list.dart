import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/addpop.dart';
import 'package:libro_admin/widgets/filter.dart';
import 'package:libro_admin/widgets/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<String?> {
  FilterCubit(super.initialFilter); 

  void selectFilter(String filter) {
    emit(filter); 
  }
}

class LibraryManagementScreen extends StatelessWidget {
  LibraryManagementScreen({super.key});

  final FilterController filterController1 = FilterController([
    'All',
    'Borrowed',
    'Out of Stock',
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is BookError) {
            log(state.message);
            return Center(child: Text(state.message));
          } 
          else if (state is BookLoaded && state.books.isNotEmpty) {
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSearchBar(),
                      Row(
                        children: [
                          const Text(
                            'Books details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),

                          ElevatedButton.icon(
                            onPressed: () {
                              showAddBookDialog(context,false);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Book'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),

                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Filter'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      FilterButton(
                        filters: filterController1.filters,
                        controller: filterController1,
                      ),

                      const SizedBox(height: 16),

                      Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 60),
                            Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Author',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Category',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Pages',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: state.books.length,
                          itemBuilder: (context, index) {
                            final book = state.books[index];
                            bool isSelected =
                                state.selectedBook != null &&
                                state.selectedBook!['uid'] == book['uid'];
                            return InkWell(
                              onTap: () {
                                context.read<BookBloc>().add(SelectBook(book));
                              },
                              child: Container(
                                color:
                                    isSelected
                                        ? AppColors.color10
                                        : (index % 2 == 0
                                            ? Colors.white
                                            : AppColors.color60),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),

                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: SizedBox(
                                          width: 40,
                                          height: 60,

                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  book['imgUrl'] ??
                                                      'https://bkacontent.com/the-right-blog-images-are-important/',
                                                ),

                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Text(book['bookname'] ?? 'null'),
                                      ),

                                      Expanded(
                                        child: Text(book['bookid'] ?? 'null'),
                                      ),

                                      Expanded(
                                        child: Text(
                                          book['authername'] ?? 'null',
                                        ),
                                      ),

                                      Expanded(
                                        child: Text(book['category'] ?? 'null'),
                                      ),

                                      Expanded(
                                        child: Text(book['pages'] ?? 'null'),
                                      ),

                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(book['stocks']),
                                          ],
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

                BookDetailsWidget(book: state.selectedBook),
              ],
            );
          } else {
            return Center(child: Text('error'));
          }
        },
      ),
    );
  }
}

class BookDetailsWidget extends StatelessWidget {
  final Map<String, dynamic>? book;
  const BookDetailsWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: AppColors.color30,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(),
      ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      child:
          book == null
              ? Center(child: Text('select user'))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(book!['bookid'] ?? 'null'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showAddBookDialog(context,true,book: book);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // db.delete(book['uid'], context);
                         showCustomDialog(context);
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: NetworkImage(
                                book?['imgUrl'] ??
                                    'https://bkacontent.com/wp-content/uploads/2016/06/Depositphotos_31146757_l-2015.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book?['bookname'] ?? 'null',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          book?['authername'] ?? 'null',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${book?['stocks'] ?? 'null'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                Text('  Not Available'),
                              ],
                            ),
                            Text(
                              ' ${book?['pages'] ?? 'null'} • ${book?['category'] ?? 'null'}',
                            ),
                          ],
                        ),
                        Text('1k+ readers'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    book?['description'] ?? 'null',
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Text(book?['location'] ?? 'null'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Current Users',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.color60,
                      border: Border.all(),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('paul walker'),
                            const Text(
                              'Exp:12/5/2025',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(20),
                  const Text(
                    'Total Fine Collected',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Gap(10),
                  Container(
                    height: 200,
                    decoration: 
                    BoxDecoration(
                      color: AppColors.color60,
                      border: Border.all()
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEFD28D),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Show Complete info'),
                    ),
                  ),
                ],
              ),
    );
  }
  Future<void> showCustomDialog(BuildContext contextS) async {
  return showDialog(
    context: contextS,
    builder: (context) => AlertDialog(
      title: Text("Delete Book"),
      content: Text("Do you really want to Delete this Book?"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: ()async {
            context.read<BookBloc>().add(
                            DeleteBook(book?['uid']),
                          );
                          Navigator.pop(context);
          },
          child: Text("delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
}
