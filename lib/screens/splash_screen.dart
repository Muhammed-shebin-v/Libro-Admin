import 'package:flutter/material.dart';
import 'package:libro_admin/screens/home_screen.dart';
import 'package:libro_admin/screens/login_screen.dart';
import 'package:libro_admin/screens/side_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);
    return Scaffold(
      body: Center(
        child: Lottie.asset('lib/assets/Animation - 1742030119292.json',height: 200,fit: BoxFit.fill),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Future.delayed(Duration(seconds: 2), () {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LibroWebLayout(currentScreen: 'Home', child: HomeScreen()),),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }
}