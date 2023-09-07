import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.green,
        secondaryHeaderColor: Colors.green.shade900,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.green,
        ));
  }
}
