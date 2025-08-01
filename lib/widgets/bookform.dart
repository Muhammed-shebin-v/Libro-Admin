import 'package:flutter/material.dart';

class BookForm extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? validation;
  final int? maxLines;
  final int? maxLength;
  const BookForm({
    super.key,
    required this.hint,
    required this.controller,
    this.maxLines,
    this.validation,
    this.maxLength
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty|| value.length<4) {
          return 'Inavlid Entry';
        }
        return null;
      },
      maxLength: maxLength,
      maxLines: maxLines,
      
      controller: controller,
      decoration: InputDecoration(
        label:Text(hint) ,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
