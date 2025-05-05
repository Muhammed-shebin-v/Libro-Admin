import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Filter Controller
class FilterController extends GetxController {
  RxString selectedFilter;

  final List<String> filters;

  FilterController(this.filters)
      : selectedFilter = filters.isNotEmpty ? filters.first.obs : ''.obs;

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }
}

// FilterButton Widget: requires controller passed from parent
class FilterButton extends StatelessWidget {
  final List<String> filters;
  final FilterController controller;

  const FilterButton({
    Key? key,
    required this.filters,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: filters.map((filter) {
        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              controller.selectFilter(filter);
            },
            child: Obx(() {
              final isSelected = controller.selectedFilter.value == filter;
              return Column(
                children: [
                  Text(
                    filter,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  isSelected
                      ? Container(
                          height: 2,
                          width: 24,
                          color: Colors.black,
                        )
                      : const SizedBox.shrink(),
                ],
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}