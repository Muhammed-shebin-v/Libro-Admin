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
import 'package:libro_admin/models/book.dart';
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

      // Now upload to Cloudinary
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

  Color _selectedColor = Colors.blue; // Default color
  String _colorString = '#0000FF';
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

  // Convert the color to a hex string
  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
  }

  bool _isHovered = false;
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

  String? _selectedCategory; // Holds the selected value from the dropdown

  // List of categories for the dropdown
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
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                      ),
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
                                    color: Colors.red,
                                    border: Border.all(),
                                  ),

                                  child: DropdownButton<String>(
                                    value:
                                        _selectedCategory,
                                    hint: Text(
                                      'Select Category',
                                    ), 
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedCategory =
                                            newValue; 
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
                                    //     log(_colorString);
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
                                    _showUserFormModal(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.color30,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(_bookId.text),
                                    const Spacer(),
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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
                                                                    _image!
                                                                        .path,
                                                                  ),
                                                                )
                                                                as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  )
                                                  : null,
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      Text(
                                        _bookName.text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _authorName.text,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _stocks.text,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
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
                                          Text(
                                            ' ${_pages.text} • ${_category.text}',
                                          ),
                                        ],
                                      ),
                                      Text('1k+ readers'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _description.text,
                                  style: const TextStyle(height: 1.5),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on),
                                    const SizedBox(width: 8),
                                    Text(_location.text),
                                  ],
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
void _showUserFormModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4), // semi-transparent black
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            // Blur background of dialog only
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(),
            ),
            _UserForm(),
          ],
        ),
      ),
    );
  }

  class _UserForm extends StatefulWidget {
  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fancy image/avatar container
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 40, color: Colors.indigo),
                ),
                const SizedBox(height: 20),

                // TextFormFields
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Confirm button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // You can save user info here
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

