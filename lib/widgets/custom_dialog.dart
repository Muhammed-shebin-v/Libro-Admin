import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/themes/fonts.dart';

Future<void> showCustomDialog({required BuildContext context,required bookId}) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Book"),
            content: Text("Do you really want to Delete this Book?"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  context.read<BookBloc>().add(DeleteBook(bookId));
                  Navigator.pop(context);
                },
                child: Text("delete", style: TextStyle(color: AppColors.secondary)),
              ),
            ],
          ),
    );
  }