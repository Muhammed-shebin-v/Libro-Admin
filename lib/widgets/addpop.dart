import 'dart:developer';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/book/book_state.dart';
import 'package:libro_admin/bloc/category/categories_bloc.dart';
import 'package:libro_admin/bloc/category/categories_event.dart';
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
  final BookModel? bookData;
  final bool isUpdate;

  const AddBookDialog({super.key, required this.isUpdate, this.bookData});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}
dynamic bookBloc;
class _AddBookDialogState extends State<AddBookDialog> {
  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      _populateFields(widget.bookData!);
      context.read<CategoryBloc>().add(
        LoadCategoriesForEdit(widget.bookData!.category),
      );
      // context.read<BookBloc>().add(LoadBookFored(existingBookModel));
      
    }
    context.read<CategoryBloc>().add(LoadCategoriesForEdit(null));
  }

  void _populateFields(BookModel data) {
    _bookNameController.text = data.bookName;
    _bookIdController.text = data.bookId!;
    _authorNameController.text = data.authorName;
    _descriptionController.text = data.description!;
    _pagesController.text = data.pages.toString();
    _stocksController.text = data.stocks.toString();
    _locationController.text = data.location ?? '';
    _selectedColor = data.color ?? Color(0xFFFFFFFF);
    for (String image in data.imageUrls!) {
      _images.add(image);
    }
  }

  // final cloudinary = CloudinaryPublic(
  //   'dwzeuyi12',
  //   'unsigned_uploads',
  //   cache: false,
  // );
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
  List<String> _images = [];
  List<String> allImageUrls = [];
  Category? selectedCategory;
   

  // final TextEditingController newCategoryController = TextEditingController();

  void _onSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate() || selectedCategory == null) {
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
    widget.isUpdate == false ? _addNewBook() : _updatePrevBook();
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

  void _addNewBook() {
    BookModel newBook = BookModel(
      bookName: _bookNameController.text.trim(),
      bookId: _bookIdController.text.trim(),
      authorName: _authorNameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: selectedCategory?.name ?? '',
      pages: int.parse(_pagesController.text.trim()),
      stocks: int.parse(_stocksController.text.trim()),
      location: _locationController.text.trim(),
      color: _selectedColor,
      imageUrls: _images,
      date: DateTime.now()
    );
    context.read<BookBloc>().add(AddBook(newBook));
  }

  void _updatePrevBook() {
    BookModel updatedBook = BookModel(
      uid: widget.bookData!.uid,
      bookName: _bookNameController.text.trim(),
      authorName: _authorNameController.text.trim(),
      bookId: _bookIdController.text.trim(),
      description: _descriptionController.text.trim(),
      category: selectedCategory!.name,
      pages: int.parse(_pagesController.text.trim()),
      stocks: int.parse(_stocksController.text.trim()),
      location: _locationController.text.trim(),
      color: _selectedColor,
      imageUrls: _images,
      date: widget.bookData!.date
    );
    context.read<BookBloc>().add(EditBook(updatedBook));
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
    if (widget.isUpdate == true) {
        context.read<BookBloc>().existingImageUrls =
            widget.bookData!.imageUrls!;
      }
       bookBloc = context.watch<BookBloc>();
      allImageUrls = [...bookBloc.existingImageUrls, ...bookBloc.uploadedUrls];
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
                    if (state is BookImagesSelected) {}

                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allImageUrls.length,
                        itemBuilder: (context, index) {
                          final selectedimage = allImageUrls[index];
                          return
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: Image.network(
                          //       selectedimage,
                          //       fit: BoxFit.cover,
                          //       width: 110,
                          //       height: 140,
                          //     ),
                          //   ),
                          // );
                          Stack(
                            children: [
                              Image.network(
                                selectedimage,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      final bloc = context.read<BookBloc>();

                                      if (bloc.existingImageUrls.contains(
                                        selectedimage,
                                      )) {
                                        bloc.existingImageUrls.remove(
                                          selectedimage,
                                        );
                                      } else if (bloc.uploadedUrls.contains(
                                        selectedimage,
                                      )) {
                                        bloc.uploadedUrls.remove(selectedimage);
                                      }

                                      // Rebuild UI manually if needed
                                      (context as Element).markNeedsBuild();
                                    });
                                  },
                                ),
                              ),
                            ],
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
                          } else if (state is EditBookLoaded) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: DropdownButton<Category>(
                                isExpanded: true,
                                underline: SizedBox(),
                                value:
                                    state.selectedCategory ??
                                    state.categories.first,
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
                  maxLength: 200,
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

void showAddBookDialog(BuildContext context, bool isUpdate, {BookModel? book}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddBookDialog(bookData: book, isUpdate: isUpdate);
    },
  );
}
