import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/db/book.dart';
import 'package:libro_admin/screens/addpop.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/long_button.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  File? _image;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();

  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadToCloudinary(_image!);
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

  final _bookName = TextEditingController();
  final _bookId = TextEditingController();
  final _authorName = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _pages = TextEditingController();
  final _stocks = TextEditingController();
  final _location = TextEditingController();
  final db = DataBaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String? _selectedCategory;
  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        title: Text('Add new Book'),
        backgroundColor: AppColors.color60,
        centerTitle: true,
      ),
      body:
          _isloading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),

                    child: Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              spacing: 10,
                              children: [
                                InkWell(
                                  onTap: () => _pickImage(),
                                  child: Container(
                                    width: 110,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                      image:
                                          _image != null
                                              ? DecorationImage(
                                                image:
                                                    kIsWeb
                                                        ? NetworkImage(
                                                          _image!.path,
                                                        )
                                                        : FileImage(
                                                              File(
                                                                _image!.path,
                                                              ),
                                                            )
                                                            as ImageProvider,
                                                fit: BoxFit.cover,
                                              )
                                              : null,
                                    ),
                                    child:
                                        _image == null
                                            ? const Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            )
                                            : null,
                                  ),
                                ),

                                Row(
                                  children: [
                                    Text('Cover Color:'),
                                    InkWell(
                                      onTap: () => _openColorPicker(),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        color: _selectedColor,
                                      ),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  controller: _bookName,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'Book name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                TextFormField(
                                  controller: _bookId,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'Book Id',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                TextFormField(
                                  controller: _authorName,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'Auther name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                TextFormField(
                                  controller: _description,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),

                                  child: Flexible(
                                    child: DropdownButton<String>(
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      value: _selectedCategory,
                                      hint: Text('Category'),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedCategory = newValue;
                                        });
                                      },
                                      items:
                                          _categories.map((category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),

                                TextFormField(
                                  controller: _pages,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'pages',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                TextFormField(
                                  controller: _stocks,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'stocks',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                TextFormField(
                                  controller: _location,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Book name';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      253,
                                      247,
                                    ),
                                    filled: true,
                                    hintText: 'location',
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                Gap(10),

                                CustomLongButton(
                                  title: 'Create',
                                  ontap: () async {
                                    // if (_uploadedImageUrl != null) {
                                    //   log(_uploadedImageUrl!);
                                    //   if (_formKey.currentState!.validate()) {
                                    //     setState(() {
                                    //       _isloading = true;
                                    //     });

                                    //     await db.create(
                                    //       Book(
                                    //         imgUrl: _uploadedImageUrl!,
                                    //         bookName: _bookName.text,
                                    //         bookId: _bookId.text,
                                    //         authorName: _authorName.text,
                                    //         description: _description.text,
                                    //         category: _category.text,
                                    //         pages: _pages.text,
                                    //         stocks: _stocks.text,
                                    //         location: _location.text,
                                    //       ),
                                    //     );

                                    //     setState(() {
                                    //       _isloading = false;
                                    //       _image = null;
                                    //     });
                                    //     _bookId.clear();
                                    //     _bookName.clear();
                                    //     _authorName.clear();
                                    //     _category.clear();
                                    //     _description.clear();
                                    //     _location.clear();
                                    //     _pages.clear();
                                    //     _stocks.clear();
                                    //     ScaffoldMessenger.of(
                                    //       context,
                                    //     ).showSnackBar(
                                    //       SnackBar(
                                    //         backgroundColor: Colors.green,
                                    //         elevation: 5.0,
                                    //         padding: EdgeInsets.all(5),
                                    //         content: Text(
                                    //           'Book added successfully',
                                    //           textAlign: TextAlign.center,
                                    //         ),
                                    //       ),
                                    //     );
                                    //   }
                                    // } else {
                                    //   ScaffoldMessenger.of(
                                    //     context,
                                    //   ).showSnackBar(
                                    //     SnackBar(
                                    //       content: Text(
                                    //         'Select a image for Book Cover',
                                    //       ),
                                    //     ),
                                    //   );
                                    // }
                                    showAddBookDialog(context,false);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
