import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/bloc/bloc/borrowed_user_bloc.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/bloc/reviews/review_bloc.dart';
import 'package:libro_admin/screens/book_details.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/addpop.dart';
import 'package:libro_admin/widgets/category_button.dart';
import 'package:libro_admin/widgets/filter.dart';
import 'package:libro_admin/widgets/search_bar.dart';
import 'package:libro_admin/widgets/sort_button.dart';

class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() => _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  String? _selectedSort;
  String? _selectedCategory;
  List<String> _categoryOptions = [];

  final filterController = FilterController(['All', 'Borrowed', 'Out of Stock']);
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchCategoryNames() async {
    try {
      final catSnap = await FirebaseFirestore.instance.collection('categories').get();
      _categoryOptions = catSnap.docs.map((doc) => doc['name'] as String).toList();
      setState(() {}); // Trigger rebuild
    } catch (e) {
      log('Error fetching category names: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryNames();
  }

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
                CustomSearchBar(
                  controller: searchController,
                  onchanged: (query) => context.read<BookBloc>().add(SearchBooks(query)),
                ),

                Row(
                  children: [
                    const Text(
                      'Books details',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => showAddBookDialog(context, false),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Book'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),

                    BlocBuilder<BookBloc, BookState>(
                      builder: (context, state) {
                        return CustomCategoryDropdown(
                          selectedCategory: _selectedCategory,
                          categoryOptions: _categoryOptions,
                          onCategoryChanged: (value) {
                            _selectedCategory = value;
                            context.read<BookBloc>().add(FilterBooksByCategory(value));
                          },
                        );
                      },
                    ),
                    const Gap(5),

                    BlocBuilder<BookBloc, BookState>(
                      builder: (context, state) {
                        return CustomSortDropdown(
                          selectedSort: _selectedSort,
                          onSortChanged: (value) {
                            _selectedSort = value;
                            context.read<BookBloc>().add(SortChanged(value));
                          },
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // FilterButton(filters: filterController.filters, controller: filterController),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      SizedBox(width: 60),
                      Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Author', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Pages', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
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
                      } else if (state is BookLoaded && state.books.isNotEmpty) {
                        return ListView.builder(
                          itemCount: state.books.length,
                          itemBuilder: (context, index) {
                            final book = state.books[index];
                            final isSelected = state.selectedBook?.uid == book.uid;
                            return InkWell(
                              onTap: () => context.read<BookBloc>().add(SelectBook(book)),
                              child: Container(
                                color: isSelected
                                    ? AppColors.color10
                                    : (index % 2 == 0 ? Colors.white : AppColors.color60),
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Container(
                                        width: 40,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          image: DecorationImage(
                                            image: NetworkImage(book.imageUrls!.first),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Text(book.bookName)),
                                    Expanded(child: Text(book.bookId ?? '')),
                                    Expanded(child: Text(book.authorName)),
                                    Expanded(child: Text(book.category ?? '')),
                                    Expanded(child: Text('${book.pages}')),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: book.color ?? Colors.red,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text('${book.currentStock}/${book.stocks}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No books found.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => BookBorrowsBloc()),
              BlocProvider(create: (_) => ReviewsBloc()),
            ],
            child: const BookDetailsWidget(),
          ),
        ],
      ),
    );
  }
}
