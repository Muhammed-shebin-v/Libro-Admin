import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/category/categories_bloc.dart';
import 'package:libro_admin/bloc/category/categories_state.dart';
import 'package:libro_admin/widgets/add_category_dialog.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.read<BookBloc>().add(LoadBooks());
            Navigator.of(context).pop();
          },
        ),
        title: Text('All Categories'),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return Center(child: Text('No categories found.'));
            }
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final cat = state.categories[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cat.color,
                      backgroundImage:
                          cat.imageUrl.isNotEmpty
                              ? NetworkImage(cat.imageUrl)
                              : null,
                      child:
                          cat.imageUrl.isEmpty
                              ? Icon(
                                Icons.category_outlined,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    title: Text(
                      cat.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Location: ${cat.location}\nBooks count: ${cat.totalBooks}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: 'Edit Category',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddCategoryDialog(toEdit: cat),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
