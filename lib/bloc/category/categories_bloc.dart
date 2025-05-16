import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/category/categories_event.dart';
import 'package:libro_admin/bloc/category/categories_state.dart';
import 'package:libro_admin/models/category.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseFirestore firestore;
  CategoryBloc(this.firestore) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<IncrementCategoryBookCount>(_onIncrementBookCount);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final snapshot = await firestore.collection('categories').get();
      final categories = snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  Future<void> _onAddCategory(
      AddCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      await firestore.collection('categories').add(event.category.toMap());
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }
  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      await firestore
          .collection('categories')
          .doc(event.oldCategory.id)
          .update(event.newCategory.toMap());

          updateCategoryNameInBooks(event.oldCategory, event.newCategory);
      add(LoadCategories());
      
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }

  Future<void> _onIncrementBookCount(
      IncrementCategoryBookCount event, Emitter<CategoryState> emit) async {
    try {
      final currentCount = event.category.totalBooks;
      await firestore
          .collection('categories')
          .doc(event.category.id)
          .update({'totalBooks': currentCount + 1});
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError('Failed to increment book count: $e'));
    }
  }
}
  Future<void> updateCategoryNameInBooks(Category oldName, Category newName) async {
  final booksRef = FirebaseFirestore.instance.collection('books');

  final querySnapshot = await booksRef.where('category', isEqualTo: oldName.name).get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({'category': newName.name});
  }
}