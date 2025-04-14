import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static  TextStyle heading1 = GoogleFonts.kalnia(
    fontSize: 28,

  );

  static  TextStyle heading2 = GoogleFonts.k2d(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static  TextStyle heading3 = GoogleFonts.k2d(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static  TextStyle body1 = GoogleFonts.k2d(fontSize: 18);

  static  TextStyle body2 = GoogleFonts.k2d(fontSize: 11);
}
class AppColors{
  static const Color color60 = Color(0xFFFDF4DC);
  static const Color color30 = Color(0xFFFEDAA1);
  static const Color color10 = Color(0xFFFFC869);
  static const Color secondary = Colors.red;
  static const Color grey=Color.fromARGB(255, 224, 222, 222);
}

