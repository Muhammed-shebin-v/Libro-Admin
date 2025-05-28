

import 'package:libro_admin/models/category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}
//new
class EditBookLoaded extends CategoryState {
  final List<Category> categories;
  final Category? selectedCategory;

  EditBookLoaded(this.categories, this.selectedCategory);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}