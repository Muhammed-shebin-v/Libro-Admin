import 'package:libro_admin/models/category.dart';

abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}
// new
class LoadCategoriesForEdit extends CategoryEvent {
  String? currentCategoryName;

  LoadCategoriesForEdit(this.currentCategoryName);
}

class AddCategoryEvent extends CategoryEvent {
  final Category category;
  AddCategoryEvent(this.category);
}
class UpdateCategoryEvent extends CategoryEvent {
  final Category oldCategory;
  final Category newCategory;

  UpdateCategoryEvent(this.oldCategory,this.newCategory);
}
class IncrementCategoryBookCount extends CategoryEvent {
  final Category category;
  IncrementCategoryBookCount(this.category);
}