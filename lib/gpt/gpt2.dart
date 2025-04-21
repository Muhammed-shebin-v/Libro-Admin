import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/screens/database.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/search_bar.dart';



class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() =>
      _LibraryManagementScreenState();
}

  Map<String, dynamic>? selectedBook;
  final db =DataBaseService();
class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Borrowed', 'fdfd'];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
           if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookError) {
            return Center(child: Text(state.message));
          } else if (state is BookLoaded && state.books.isNotEmpty) {
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
                        // Sort Button
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.sort),
                          label: const Text('Sort'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Filter Button
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

                    // Filter Tabs
                    Row(
                      children:
                          _filters.map((filter) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      filter,
                                      style: TextStyle(
                                        fontWeight:
                                            _selectedFilter == filter
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (_selectedFilter == filter)
                                      Container(
                                        height: 2,
                                        width: 24,
                                        color: Colors.black,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Divider
                    Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 60), // Space for image
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

                    // Book List
                    Expanded(
                      child: ListView.builder(
                        itemCount:state.books.length,
                        itemBuilder: (context, index) {
                          final  book = state.books[index];
                           bool isSelected =selectedBook != null && selectedBook!['bookid'] == book['bookid'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                         selectedBook = book;
                              });
                            },
                            child: Container(
                              color:isSelected
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
                                    // Book Cover Image
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: SizedBox(
                                        width: 40,
                                        height: 60,
                                        // child: AspectRatio(
                                        //   aspectRatio: 0.7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/atomic_habits.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ),
                                    // Book Name
                                    Expanded(child: Text(book['bookname']??'null')),
                                    // Book ID
                                    Expanded(child: Text(book['bookid']??'null')),
                                    // Author
                                    Expanded(child: Text(book['authername']??'null')),
                                    // Category
                                    Expanded(child: Text(book['category']??'null')),
                                    // Pages
                                    Expanded(
                                      child: Text(book['pages']??'null'),
                                    ),
                                    // Status
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

              BookDetailsWidget()]);
         
          
          }else{
            return Center(child: Text('error'),);
          }
          
        }
      ),
    );
  }
}

class BookDetailsWidget extends StatelessWidget {

  const BookDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final book = selectedBook;
    return 
     Container(
                width: 400,
                decoration: BoxDecoration(
                  color: AppColors.color30,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                child:
           book==null?Center(child: Text('select user'),):
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(book['bookid']??'null'),
            const Spacer(),
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            IconButton(icon: const Icon(Icons.delete), onPressed: () {
              db.delete(book['uid'],context);
            }),
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
                  // image: DecorationImage(
                  //   image: AssetImage('assets/atomic_habits.png'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              const SizedBox(height: 8),
               Text(
                book['bookname']??'null',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
               Text(book['authername']??'null', style: TextStyle(color: Colors.grey)),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${book['stocks']??'null'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Text(' ${book['pages']??'null'} • ${book['category']??'null'}'),
                ],
              ),
              Text('1k+ readers'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(book['description']??'null', style: const TextStyle(height: 1.5)),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 8),
            Text(book['location']??'null'),
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
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text('paul walker'),
                  const Text('Exp:12/5/2025', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
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
     )
    );
  }
}
