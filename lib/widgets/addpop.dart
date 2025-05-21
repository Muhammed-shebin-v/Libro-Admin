import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/bloc/category/categories_bloc.dart';
import 'package:libro_admin/bloc/category/categories_state.dart';
import 'package:libro_admin/db/book.dart';
import 'package:libro_admin/models/book.dart';
import 'package:libro_admin/models/category.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/add_category_dialog.dart';
import 'package:libro_admin/widgets/bookform.dart';
import 'package:libro_admin/widgets/counter.dart';
import 'package:libro_admin/widgets/long_button.dart';

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
    if (widget.isUpdate) {
      _populateFields(widget.bookData!);
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    _bookNameController.text = data['bookName'] ?? '';
    _bookIdController.text = data['bookId'] ?? '';
    _authorNameController.text = data['authorName'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _pagesController.text = data['pages'] ?? '';
    _stocksController.text = data['stocks'] ?? '';
    _locationController.text = data['location'] ?? '';
  }

  final cloudinary = CloudinaryPublic(
    'dwzeuyi12',
    'unsigned_uploads',
    cache: false,
  );
  Color _selectedColor = Colors.blue;
  Color _colorr = Colors.blue;

  final _bookNameController = TextEditingController();
  final _bookIdController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagesController = TextEditingController();
  final _stocksController = TextEditingController();
  final _locationController = TextEditingController();
  final db = DataBaseService();
  final _formKey = GlobalKey<FormState>();
  Category? selectedCategory;
  final TextEditingController newCategoryController = TextEditingController();

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate() ||
        // _uploadedImageUrl == null ||
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
      // imgUrl: _uploadedImageUrl!,
      bookName: _bookNameController.text.trim(),
      bookId: _bookIdController.text.trim(),
      authorName: _authorNameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: selectedCategory?.name ?? '',
      pages: _pagesController.text.trim(),
      stocks: _stocksController.text.trim(),
      location: _locationController.text.trim(),
      color: _selectedColor,
    );
    Map<String, dynamic> updatedBook = {
      'uid': widget.bookData?['uid'] ?? '',
      'bookName': _bookNameController.text.trim(),
      'bookId': _bookIdController.text.trim(),
      'authorName': _authorNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': selectedCategory!.name,
      'pages': _pagesController.text.trim(),
      'stocks': _stocksController.text.trim(),
      'location': _locationController.text.trim(),
      // 'imgUrl': _uploadedImageUrl!,
      'color': _selectedColor.toARGB32(),
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

  void _openColorPickerbook() {
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
                      IconButton(
                        icon: Icon(Icons.add_a_photo),

                        onPressed:
                            () =>
                                context.read<BookBloc>().add(PickImagesEvent()),
                      ),
                      Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'cover:  ',
                                style: TextStyle(fontSize: 16),
                              ),
                              InkWell(
                                onTap: () => _openColorPickerbook(),
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
                BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    List<XFile> images = [];

                    if (state is BookImagesSelected) {
                      images = state.images;
                    }

                    return SizedBox(
                      height: 200,
                      child:
                          images.isEmpty
                              ? const Text('No images selected.')
                              : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  final selectedImage = images[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 110,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        selectedImage.path,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                    );
                  },
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
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CategoryLoaded) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: DropdownButton<Category>(
                                isExpanded: true,
                                underline: SizedBox(),
                                value: selectedCategory,
                                hint: Text('    Select Category'),
                                items:
                                    state.categories
                                        .map(
                                          (cat) => DropdownMenuItem<Category>(
                                            value: cat,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: cat.color,
                                                  backgroundImage:
                                                      cat.imageUrl.isNotEmpty
                                                          ? NetworkImage(
                                                            cat.imageUrl,
                                                          )
                                                          : null,
                                                  radius: 14,
                                                  child:
                                                      cat.imageUrl.isEmpty
                                                          ? Icon(
                                                            Icons
                                                                .category_outlined,
                                                            color:
                                                                AppColors.white,
                                                            size: 16,
                                                          )
                                                          : null,
                                                ),
                                                SizedBox(width: 10),
                                                Text(cat.name),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (cat) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                },
                              ),
                            );
                          } else if (state is CategoryError) {
                            return Text(
                              state.message,
                              style: TextStyle(color: AppColors.secondary),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => showAddCategoryDialog(context),
                      icon: Icon(Icons.add),
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
                  ontap: () {
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
