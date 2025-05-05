import 'package:flutter/material.dart';
import 'package:libro_admin/screens/home_screen.dart';
import 'package:libro_admin/screens/login_screen.dart';
import 'package:libro_admin/screens/side_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginStatus(context);
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Lottie.asset('lib/assets/Animation - 1742030119292.json',height: 200,fit: BoxFit.fill),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn =  prefs.getBool('isLoggedIn')??false;

    Future.delayed(Duration(seconds: 3), () {
      if (isLoggedIn==true) {
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