
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/screens/book_details.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/addpop.dart';
import 'package:libro_admin/widgets/filter.dart';
import 'package:libro_admin/widgets/search_bar.dart';

class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() => _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  String? _selectedSort;
  final List<String> _sortOptions = ['Alphabetical', 'Latest'];
  final FilterController filterController1 = FilterController([
    'All',
    'Borrowed',
    'Out of Stock',
  ]);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body:
      Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(
                  controller: searchController,
                  onchanged: (query) {
                    context.read<BookBloc>().add(SearchBooks(query));
                  },
                ),
              
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
                        showAddBookDialog(context, false);
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
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) => const AllCategoriesScreen(),
                        //   ),
                        // );
                        context.read<BookBloc>().add(
                          LoadBooksByCategory('tech'),
                        );
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Categories'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    Gap(5),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BlocBuilder<BookBloc, BookState>(
                        builder: (context, state) {
                          return DropdownButton<String>(
                            underline: const SizedBox(),
                            hint: Text(_selectedSort ?? 'Sort by'),
                            value: _selectedSort,
                            // value: ,
                            items:
                                _sortOptions.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _selectedSort = newValue;
                                context.read<BookBloc>().add(
                                  SortChanged(newValue),
                                );
                              }
                            },
                          );
                        },
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
                  child: BlocBuilder<BookBloc, BookState>(
                    builder: (context, state) {
                      if (state is BookLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BookError) {
                        log(state.message);
                        return Center(child: Text(state.message));
                      } else if (state is BookLoaded &&
                          state.books.isNotEmpty) {
                        return Row(
                          children: [
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
                                      context.read<BookBloc>().add(
                                        SelectBook(book),
                                      );
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ),
                                              child: SizedBox(
                                                width: 40,
                                                height: 60,

                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        book['imageUrls'][0] ??
                                                            'https://bkacontent.com/the-right-blog-images-are-important/',
                                                      ),

                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(
                                                book['bookName'] ?? 'null',
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(
                                                book['bookId'] ?? 'null',
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(
                                                book['authorName'] ?? 'null',
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(
                                                book['category'] ?? 'null',
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(book['pages'].toString(),
                                              ),
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
                                                          book['color'] != null
                                                              ? Color(
                                                                book['color'],
                                                              )
                                                              : Colors.red,
                                                      //  Colors.red
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    book['stocks'].toString(),
                                                  ),
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
                        );
                      } else {
                        return Center(child: Text('nthoo pattikn ttoooo!'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
   
              BookDetailsWidget(),
             
          
        ],
      ),
    );
  }
}
