import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/bloc/borrowed_books_dart_bloc.dart';
import 'package:libro_admin/bloc/bloc/borrowed_books_dart_event.dart';
import 'package:libro_admin/bloc/book/book_bloc.dart';
import 'package:libro_admin/bloc/book/book_event.dart';
import 'package:libro_admin/bloc/category/categories_bloc.dart';
import 'package:libro_admin/bloc/category/categories_event.dart';
import 'package:libro_admin/bloc/user/users_bloc.dart';
import 'package:libro_admin/bloc/user/users_event.dart';
import 'package:libro_admin/screens/borrow_list.dart';
import 'package:libro_admin/screens/splash_screen.dart';
import 'package:libro_admin/widgets/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()..add(FetchUsers())),
        BlocProvider(create: (context) => BookBloc()..add(LoadBooks())),
        BlocProvider(create: (_) => CategoryBloc(FirebaseFirestore.instance)..add(LoadCategories())),
        BlocProvider(create: (_) => BorrowedBooksBloc()..add(LoadBorrowedBooks())),
      ],
      child: LibroAdmin(),
    ),
  );
}

class LibroAdmin extends StatelessWidget {
  const LibroAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen(),);
  }
}
