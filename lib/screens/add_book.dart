import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/screens/database.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/long_button.dart';

class AddBook extends StatelessWidget {
  AddBook({super.key});

  final _bookName = TextEditingController();
  final _bookId = TextEditingController();
  final _authorName = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _pages = TextEditingController();
  final _stocks = TextEditingController();
  final _location = TextEditingController();
  final db = DataBaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        title: Text('Add new Book'),
        backgroundColor: AppColors.color60,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.color30,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      spacing: 10,
                      children: [
                        Gap(20),
                        Column(
                          children: [
                            Container(
                              width: 100,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 92,
                                      height: 105,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Image(
                                        image: AssetImage(''),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 3,
                                    right: 0,
                                    child: Container(
                                      width: 94,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Cover Color:'),
                            Container(
                              height: 20,
                              width: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _bookName,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'Book name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _bookId,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'Book Id',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _authorName,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'Auther name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _description,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _category,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _pages,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'pages',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _stocks,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'stocks',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          controller: _location,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 253, 247),
                            filled: true,
                            hintText: 'location',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(10),
                CustomLongButton(
                  title: 'Create',
                  ontap: () async {
                    await db.create(
                     Book(bookName: _bookName.text, bookId: _bookId.text, authorName: _authorName.text, description: _description.text, category: _category.text, pages: _pages.text, stocks: _stocks.text, location: _location.text)
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
