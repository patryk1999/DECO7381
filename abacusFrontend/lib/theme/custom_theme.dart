import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: CustomColors.green,
        secondaryHeaderColor: CustomColors.darkGreen,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: CustomColors.green,
        ));
  }
}
