import 'dart:developer';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/db/book.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/widgets/bookform.dart';
import 'package:libro_admin/widgets/counter.dart';
import 'package:libro_admin/widgets/long_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBookDialog extends StatefulWidget {
  final Map<String, dynamic>? bookData;
  final bool isUpdate;

  const AddBookDialog({super.key, required this.isUpdate, this.bookData});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  @override
  void initState() {
    super.initState();
    if (widget.bookData != null) {
      _populateFields(widget.bookData!);
      _loadCategories().then((_) {
        if (widget.bookData != null) {
          final categoryFromData = widget.bookData!['category'] as String?;
          if (categoryFromData != null &&
              categories.contains(categoryFromData)) {
            selectedCategory = categoryFromData;
          } else {
            selectedCategory = null;
          }
          setState(() {});
        }
      });
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    _bookNameController.text = data['bookname'] ?? '';
    _bookIdController.text = data['bookid'] ?? '';
    _authorNameController.text = data['authername'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    selectedCategory = data['category'] ?? '';
    _pagesController.text = data['pages'] ?? '';
    _stocksController.text = data['stocks'] ?? '';
    _locationController.text = data['location'] ?? '';
    _uploadedImageUrl = data['imgUrl'] ?? '';
    // _selectedColor=Color(colorValue);
    if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
      image = XFile(_uploadedImageUrl!);
    }
  }

  String? _uploadedImageUrl;
  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );
  // Color _selectedColor = Colors.blue;
  // Color _colorr = Colors.blue;
  XFile? image;
  final _bookNameController = TextEditingController();
  final _bookIdController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();
  final _stocksController = TextEditingController();
  final _locationController = TextEditingController();
  final db = DataBaseService();
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  List<String> categories = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Biography',
  ];
  final TextEditingController newCategoryController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image = pickedFile;
    });
    if (pickedFile != null) {
      await _uploadToCloudinary(File(pickedFile.path));
    }
  }

  Future<void> _uploadToCloudinary(File imageFile) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      _uploadedImageUrl = response.secureUrl;
      log("Image Uploaded: $_uploadedImageUrl");
    } catch (e) {
      log('Cloudinary upload error: $e');
    }
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories = prefs.getStringList('categories');
    if (savedCategories != null && savedCategories.isNotEmpty) {
      setState(() {
        categories = savedCategories;
      });
    }
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', categories);
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(hintText: 'Enter new category'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                final newCat = newCategoryController.text.trim();
                if (newCat.isNotEmpty && !categories.contains(newCat)) {
                  setState(() {
                    categories.add(newCat);
                    selectedCategory = newCat;
                  });
                  await _saveCategories();
                  newCategoryController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate() ||
        _uploadedImageUrl == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 231, 19, 19),
          elevation: 5.0,
          padding: EdgeInsets.all(5),
          content: Text(
            'Enter All Details Correctly',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    final book = Book(
      imgUrl: _uploadedImageUrl!,
      bookName: _bookNameController.text.trim(),
      bookId: _bookIdController.text.trim(),
      authorName: _authorNameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: selectedCategory ?? '',
      pages: _pagesController.text.trim(),
      stocks: _stocksController.text.trim(),
      location: _locationController.text.trim(),
      // color: _selectedColor.toString()
    );
    Map<String, dynamic> updatedBook = {
      'uid': widget.bookData?['uid'] ?? '',
      'bookname': _bookNameController.text.trim(),
      'bookid': _bookIdController.text.trim(),
      'authername': _authorNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': selectedCategory,
      'pages': _pagesController.text.trim(),
      'stocks': _stocksController.text.trim(),
      'location': _locationController.text.trim(),
      'imgUrl': _uploadedImageUrl!,
      // 'color':_selectedColor.toString()
    };
    widget.isUpdate == true
        ? context.read<BookBloc>().add(EditBook(updatedBook))
        : context.read<BookBloc>().add(AddBook(book));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        elevation: 5.0,
        padding: EdgeInsets.all(5),
        content: Text('Book added successfully', textAlign: TextAlign.center),
      ),
    );
  }

  // void _openColorPicker() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Pick a Color'),
  //         content: SingleChildScrollView(
  //           child: ColorPicker(
  //             pickerColor: _selectedColor,
  //             onColorChanged: (color) {
  //               _colorr = color;
  //             },
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               setState(() {
  //                 _selectedColor = _colorr;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Book',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => _pickImage(),
                        child: Container(
                          width: 110,
                          height: 140,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              image != null
                                  ? Image.network(image!.path, fit: BoxFit.fill)
                                  : Icon(Icons.image),
                        ),
                      ),
                      Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     const Text(
                          //       'cover:  ',
                          //       style: TextStyle(fontSize: 16),
                          //     ),
                          //     InkWell(
                          //       onTap: () => _openColorPicker(),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           border: Border.all(),
                          //           color: _selectedColor,
                          //         ),
                          //         height: 50,
                          //         width: 50,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          CustomCounter(
                            controller: _stocksController,
                            title: 'Stocks:  ',
                            width: 30,
                            maxLenght: 2,
                          ),
                          CustomCounter(
                            controller: _pagesController,
                            title: 'Pages:  ',
                            width: 45,
                            maxLenght: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                BookForm(hint: 'Book Name', controller: _bookNameController),
                BookForm(hint: 'Book ID', controller: _bookIdController),
                BookForm(
                  hint: 'Author Name',
                  controller: _authorNameController,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      // width: 120,
                      // height: 50,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: 'category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        value: selectedCategory,
                        items:
                            categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: _addNewCategory,
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),

                BookForm(
                  hint: 'Description',
                  controller: _descriptionController,
                  maxLines: 4,
                ),
                BookForm(hint: 'Location', controller: _locationController),
                CustomLongButton(
                  title: widget.isUpdate == true ? 'Update' : 'Add',
                  ontap: ()  {
                    _onSubmit(context);
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

void showAddBookDialog(
  BuildContext context,
  bool isUpdate, {
  Map<String, dynamic>? book,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddBookDialog(bookData: book, isUpdate: isUpdate);
    },
  );
}
