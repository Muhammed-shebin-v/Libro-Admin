import 'package:flutter/material.dart';

class BookForm extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? validation;
  final int? maxLines;
  const BookForm({
    super.key,
    required this.hint,
    required this.controller,
    this.maxLines,
    this.validation
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

      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
