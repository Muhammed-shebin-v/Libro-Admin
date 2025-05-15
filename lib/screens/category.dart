import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:libro_admin/bloc/category/categories_bloc.dart';
import 'package:libro_admin/bloc/category/categories_event.dart';
import 'package:libro_admin/models/category.dart';



class AddCategoryDialog extends StatefulWidget {
  final Category? toEdit;
  const AddCategoryDialog({super.key, this.toEdit});

  @override
  AddCategoryDialogState createState() => AddCategoryDialogState();
}

class AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  late TextEditingController _locationController;
  late Color _pickedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.toEdit?.name ?? '');
    _imageUrlController = TextEditingController(
      text: widget.toEdit?.imageUrl ?? '',
    );
    _locationController = TextEditingController(
      text: widget.toEdit?.location ?? '',
    );
    _pickedColor = widget.toEdit?.color ?? Colors.blue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.toEdit != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Category' : 'Add New Category'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 10),
              // TextFormField(
              //   controller: _imageUrlController,
              //   decoration: InputDecoration(
              //     labelText: 'Image URL (optional)',
              //     helperText:
              //         'Paste a link to an image (jpg, png) to represent category',
              //   ),
              //   keyboardType: TextInputType.url,
              //   validator: (v) {
              //     if (v == null || v.trim().isEmpty) return null;
              //     final valid = Uri.tryParse(v)?.hasAbsolutePath ?? false;
              //     if (!valid) return 'Enter valid URL or leave empty';
              //     return null;
              //   },
              // ),
              SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Category Location'),
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Pick Color:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _openColorPicker,
                    child: CircleAvatar(
                      backgroundColor: _pickedColor,
                      radius: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _submit(context, widget.toEdit!),
          child: Text(isEdit ? 'Update' : 'Confirm'),
        ),
      ],
    );
  }


  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickedColor,
              onColorChanged: (color) {
                _pickedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  _pickedColor = _pickedColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submit(BuildContext context, Category cat) {
    if (!_formKey.currentState!.validate()) return;

    final category = Category(
      id: widget.toEdit?.id ?? '',
      name: _nameController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      color: _pickedColor,
      location: _locationController.text.trim(),
      totalBooks: widget.toEdit?.totalBooks ?? 0,
    );

    if (widget.toEdit == null) {
      BlocProvider.of<CategoryBloc>(context).add(AddCategoryEvent(category));
    } else {
      BlocProvider.of<CategoryBloc>(
        context,
      ).add(UpdateCategoryEvent(cat, category));
    }
    Navigator.of(context).pop();
  }
}

