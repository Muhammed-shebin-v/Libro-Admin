import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomForm extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isPassword;
  const CustomForm({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.hint,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20)),
        TextFormField(
          obscureText: isPassword ?? false,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(18.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 162, 65, 0),
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorStyle: TextStyle(color: const Color.fromARGB(255, 255, 162, 155)),
            fillColor: const Color.fromARGB(255, 250, 223, 141),
            filled: true,
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
        Gap(10),
      ],
    );
  }
}
