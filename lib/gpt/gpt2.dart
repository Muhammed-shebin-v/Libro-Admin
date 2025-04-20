import 'package:flutter/material.dart';


class Book {
  final String id;
  final String name;
  final String author;
  final String category;
  final int pages;
  final bool isBorrowed;
  final String coverUrl;
  final double rating;
  final String description;
  final String location;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.category,
    required this.pages,
    required this.isBorrowed,
    required this.coverUrl,
    required this.rating,
    required this.description,
    required this.location,
  });
}

class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() => _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  int _selectedBookIndex = 0;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Borrowed', 'fdfd'];

  final List<Book> _books = List.generate(
    10,
    (index) => Book(
      id: '656556665',
      name: 'Atomic Habits',
      author: 'James Clear',
      category: 'Fictional',
      pages: 208,
      isBorrowed: true,
      coverUrl: 'assets/atomic_habits.png',
      rating: 4.6,
      description:
          'Atomic Habits by James Clear is a transformative guide on building good habits and breaking bad ones. It explores how small, consistent changes lead to remarkable results over time. Using science-backed strategies, Clear explains the power of habit formation.',
      location: '1st floor,1A shelf,4th row',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Middle Section - Book List
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.search, color: Colors.grey),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Handle search
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Books details header with Sort and Filter
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
                    children: _filters.map((filter) {
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
                                  fontWeight: _selectedFilter == filter
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
                  
                  // Table Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 60), // Space for image
                        Expanded(
                          child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Author', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Pages', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  
                  // Divider
                  Divider(color: Colors.grey),
                  
                  // Book List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedBookIndex = index;
                            });
                          },
                          child: Container(
                            color: _selectedBookIndex == index
                                ? Colors.amber
                                : Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  // Book Cover Image
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: SizedBox(
                                      width: 60,
                                      child: AspectRatio(
                                        aspectRatio: 0.7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            borderRadius: BorderRadius.circular(4),
                                            image: DecorationImage(
                                              image: AssetImage('assets/atomic_habits.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Book Name
                                  Expanded(

                                    child: Text('Book Name'),
                                  ),
                                  // Book ID
                                  Expanded(
                                    child: Text(book.id),
                                  ),
                                  // Author
                                  Expanded(
                                    child: Text('Author name'),
                                  ),
                                  // Category
                                  Expanded(
                                    child: Text(book.category),
                                  ),
                                  // Pages
                                  Expanded(
                                    child: Text(book.pages.toString()),
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
                                        Text('All Borrowed'),
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
          ),
          
          // Right Section - Book Details
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8DDA0),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              child: BookDetailsWidget(book: _books[_selectedBookIndex]),
            ),
          ),
        ],
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: 200,
  //     color: const Color(0xFFF5E1B5),
  //     child: Column(
  //       children: [
  //         // App Logo or Title
  //         Container(
  //           height: 80,
  //           color: Colors.pink.shade200,
  //           width: double.infinity,
  //         ),
  //         const SizedBox(height: 20),
          
  //         // Navigation Items
  //         for (int i = 0; i < 7; i++)
  //           ListTile(
  //             leading: const Icon(Icons.arrow_forward),
  //             title: const Text('title'),
  //             onTap: () {
  //               // Handle navigation
  //             },
  //           ),
          
  //         const Spacer(),
          
  //         // Logout Button
  //         ListTile(
  //           leading: const Icon(Icons.arrow_back, color: Colors.red),
  //           title: const Text('Log out', style: TextStyle(color: Colors.red)),
  //           onTap: onLogout,
  //         ),
  //         const SizedBox(height: 16),
  //       ],
//       ),
//     );
//   }
// }

class BookDetailsWidget extends StatelessWidget {
  final Book book;

  const BookDetailsWidget({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book ID and Edit/Delete buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(book.id),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
        
        // Book Cover and Basic Info
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
                    image: AssetImage('assets/atomic_habits.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Book Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Author name',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Rating and Info
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rating
              Row(
                children: [
                  Text(
                    '${book.rating}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.star, color: Colors.amber),
                ],
              ),
              
              // Status
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.shade100,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: const Text('Not Available'),
              ),
              
              // Pages and Category
              Text('198 pages • ${book.category}'),
              
              // Readers
              const Text('1k+ readers'),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Book Description
        Text(
          book.description,
          style: const TextStyle(height: 1.5),
        ),
        
        const SizedBox(height: 16),
        
        // Location
        Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 8),
            Text(book.location),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Current Users
        const Text(
          'Current Users',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Users List
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
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
        
        const Spacer(),
        
        // Show Complete Info Button
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
    );
  }
}
