import 'dart:developer';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/db/book.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/widgets/bookform.dart';
import 'package:libro_admin/widgets/counter.dart';
import 'package:libro_admin/widgets/long_button.dart';

class AddBookDialog extends StatefulWidget {
  const AddBookDialog({super.key});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  String? _uploadedImageUrl;

  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
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
      setState(() {
        _uploadedImageUrl = response.secureUrl;
      });
      log("Image Uploaded: $_uploadedImageUrl");
    } catch (e) {
      log('Cloudinary upload error: $e');
    }
  }

  Color _selectedColor = Colors.blue;
  Color _colorr = Colors.blue;

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                _colorr = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  _selectedColor = _colorr;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _bookNameController = TextEditingController();
  final _bookIdController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _pagesController = TextEditingController();
  final _stocksController = TextEditingController();
  final _locationController = TextEditingController();
  final db = DataBaseService();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
  ];

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
                              _uploadedImageUrl != null
                                  ? Image.network(_uploadedImageUrl!)
                                  : Icon(Icons.image),
                        ),
                      ),
                      Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'cover:',
                                style: TextStyle(fontSize: 16),
                              ),
                              InkWell(
                                onTap: () => _openColorPicker(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: _selectedColor,
                                  ),
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ],
                          ),
                          CustomCounter(
                            controller: _stocksController,
                            title: 'Stocks',
                            width: 30,
                            maxLenght: 2,
                          ),
                          CustomCounter(
                            controller: _pagesController,
                            title: 'Pages',
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
                DropdownButtonFormField<String>(
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
                  items:
                      [
                        'Fiction',
                        'Non-Fiction',
                        'Science',
                        'History',
                        'Biography',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {},
                ),
                BookForm(
                  hint: 'Description',
                  controller: _descriptionController,
                  maxLines: 4,
                ),
                BookForm(hint: 'Location', controller: _locationController),
                CustomLongButton(
                  title: 'Add',
                  ontap: () async {
                   
                      if (_formKey.currentState!.validate() && _uploadedImageUrl != null) {
                        Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            elevation: 5.0,
                            padding: EdgeInsets.all(5),
                            content: Text(
                              'Book added successfully',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        await db.create(
                          Book(
                            imgUrl: _uploadedImageUrl!,
                            bookName: _bookNameController.text,
                            bookId: _bookIdController.text,
                            authorName: _authorNameController.text,
                            description: _descriptionController.text,
                            category: _categoryController.text,
                            pages: _pagesController.text,
                            stocks: _stocksController.text,
                            location: _locationController.text,
                          ),
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color.fromARGB(255, 231, 19, 19),
                            elevation: 5.0,
                            padding: EdgeInsets.all(5),
                            content: Text(
                              'Enter All Details Correctly',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    } 
           
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showAddBookDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddBookDialog();
    },
  );
}
