import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

List<DocumentSnapshot> _searchResults = [];

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(),
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
                      searchBooks(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          _searchResults.isEmpty
              ? const SizedBox()
              : SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final data =
                        _searchResults[index].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: Icon(Icons.book),
                      title: Text(data['bookName'] ?? ''),
                      subtitle: Text(
                        "Author: ${data['authorName'] ?? ''} | Category: ${data['category'] ?? ''}",
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  searchBooks(String query) async {
    final allBooksSnapshot =
        await FirebaseFirestore.instance.collection('books').get();

    final results =
        allBooksSnapshot.docs.where((doc) {
          final data = doc.data();
          final title = (data['bookName'] ?? '').toString().toLowerCase();
          final author = (data['authorName'] ?? '').toString().toLowerCase();
          final category = (data['category'] ?? '').toString().toLowerCase();

          return title.contains(query) ||
              author.contains(query) ||
              category.contains(query);
        }).toList();
    setState(() {
      _searchResults = results;
    });
  }
}
