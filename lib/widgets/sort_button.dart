import 'package:flutter/material.dart';
import 'package:libro_admin/db/const.dart';

class CustomSortDropdown extends StatelessWidget {
  final String? selectedSort;
  final Function(String) onSortChanged;
  final Color borderColor;

  const CustomSortDropdown({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        hint: Text(selectedSort ?? 'Sort by'),
        value: selectedSort,
        items: ConstValues.sortOptions.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onSortChanged(newValue);
          }
        },
      ),
    );
  }
}