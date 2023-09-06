import 'package:abacusfrontend/pages/signUpScreen.dart';
import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpScreen());
    //return MaterialApp(home: LoginScreen());
  }
}
