import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/addpop.dart';
import 'package:libro_admin/widgets/custom_dialog.dart';

class BookDetailsWidget extends StatelessWidget {
  const BookDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.color30,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookError) {
              log(state.message);
              return Center(child: Text(state.message));
            } else if (state is BookLoaded && state.books.isNotEmpty) {
              
              if (state.selectedBook == null) {
                return Center(child: Text('select a user'));
              } else {
                final book = state.selectedBook!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(book['bookId'] ?? 'null'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showAddBookDialog(context, book: book, true);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showCustomDialog(
                              context: context,
                              bookId: book['uid'],
                            );
                          },
                        ),
                      ],
                    ),
                    Divider(),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child:
                                book['imageUrls'] == null
                                    ? const Text('No images selected.')
                                    : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: book['imageUrls'].length,
                                      itemBuilder: (context, index) {
                                        final selectedImage =
                                            book['imageUrls'][index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 110,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Image.network(
                                              selectedImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            book['bookName'] ?? 'null',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            book['authorName'] ?? 'null',
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
                                '${book['stocks'] ?? 'null'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.star, color: AppColors.color10),
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
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  Text('  Not Available'),
                                ],
                              ),
                              Text(
                                ' ${book['pages'] ?? 'null'} • ${book['category'] ?? 'null'}',
                              ),
                            ],
                          ),
                          Text('1k+ readers'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      book['description'] ?? 'null',
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 8),
                        Text(book['location'] ?? 'null'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Current Users',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                                backgroundColor: AppColors.grey,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.white,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.color60,
                        border: Border.all(),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.color10,
                          foregroundColor: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Show Complete info'),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
