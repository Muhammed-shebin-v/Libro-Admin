import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/screens/home_screen.dart';
import 'package:libro_admin/screens/side_bar.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/form.dart';
import 'package:libro_admin/widgets/long_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final String predefinedUsername = "LibroAdmin@gmail.com";
  final String predefinedPassword = "123456789";

  void _login(context) async {
    if (_emailController.text == predefinedUsername &&
        _passwordController.text == predefinedPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LibroWebLayout(currentScreen: 'Home', child: HomeScreen()),),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(30),
                  Text('Hi,Welcome Admin!', style: AppFonts.heading1),
                  Text('we happy to see you,sign in to your account'),
                  Gap(50),
                  CustomForm(
                    title: 'Email',
                    hint: 'enter email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  CustomForm(
                    title: 'Password',
                    hint: 'enter password',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  
                  Gap(50),
                  CustomLongButton(
                    title: 'Log in',
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
                        _login(context);
                      }
                    },
                  ),
                  Gap(10),
                  Gap(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
