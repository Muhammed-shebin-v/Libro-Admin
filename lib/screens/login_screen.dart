import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro_admin/screens/home.dart';
import 'package:libro_admin/widgets/side_bar.dart';
import 'package:libro_admin/themes/fonts.dart';
import 'package:libro_admin/widgets/form.dart';
import 'package:libro_admin/widgets/long_button.dart';
import 'package:lottie/lottie.dart';
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
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  LibroWebLayout(currentScreen: 'DashBoard', child: DashboardPage()),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: Center(
        child: Container(
          width: 850,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        Text('Welcome Admin!', style: AppFonts.heading1),
                        const Text('we happy to see you,sign in to your admin account'),
                        const Gap(50),
                        CustomForm(
                          title: 'Email',
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
                          obsecure: true,
                          title: 'Password',
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

                        const Gap(30),
                        CustomLongButton(
                          title: 'Log in',
                          ontap: () async {
                            if (_formKey.currentState!.validate()) {
                              _login(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                  child: Lottie.asset(
                    'lib/assets/Animation - 1742030119292.json',
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
