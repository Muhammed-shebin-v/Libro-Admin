import 'package:flutter/material.dart';

class CustomCategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categoryOptions;
  final Function(String) onCategoryChanged;
  final Color borderColor;

  const CustomCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categoryOptions,
    required this.onCategoryChanged,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        hint: Text(selectedCategory ?? 'Filter by Category'),
        value: selectedCategory,
        items: categoryOptions.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onCategoryChanged(newValue);
          }
        },
      ),
    );
  }
}