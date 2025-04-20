import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro_admin/bloc/bloc/users_bloc.dart';
import 'package:libro_admin/bloc/bloc/users_event.dart';
import 'package:libro_admin/gpt/gpt1.dart';
import 'package:libro_admin/screens/Sidebar.dart';
import 'package:libro_admin/widgets/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BlocProvider(create: (context) => UserBloc()..add(FetchUsers()), child: LibroAdmin()));
}

class LibroAdmin extends StatelessWidget {
  const LibroAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: 
      LibroWebLayout(currentScreen: 'Dashboard', 
      child: UserManagementScreen()),
    );
  }
}
