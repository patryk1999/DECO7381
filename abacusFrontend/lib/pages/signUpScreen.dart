import 'dart:convert';

import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:abacusfrontend/components/input_field.dart';
import '../components/simple_elevated_button.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  final Function(String? firstname, String? lastname, String? usersame,
      String? email, String? password)? onSubmitted;
  const SignUpScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String firstname, lastname, username, email, password;
  String? firstnameError,
      lastnameError,
      usernameError,
      emailError,
      passwordError,
      signUpError;
  Function(String? firstname, String? lastname, String? username, String? email,
      String? password)? get onSubmitted => widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    firstname = '';
    lastname = '';
    username = '';
    email = '';
    password = '';
    firstnameError = null;
    lastnameError = null;
    usernameError = null;
    emailError = null;
    passwordError = null;
    signUpError = null;
  }

  void resetErrorText() {
    setState(() {
      firstnameError = null;
      lastnameError = null;
      usernameError = null;
      emailError = null;
      passwordError = null;
      signUpError = null;
    });
  }

  bool validate() {
    resetErrorText();

    bool isValid = true;
    if (firstname.isEmpty) {
      setState(() {
        firstnameError = 'First name is invalid';
      });
      isValid = false;
    }
    if (lastname.isEmpty) {
      setState(() {
        lastnameError = 'Last name is invalid';
      });
      isValid = false;
    }
    if (username.isEmpty) {
      setState(() {
        usernameError = 'Username is invalid';
      });
      isValid = false;
    }
    if (email.isEmpty) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Password is invalid';
      });
      isValid = false;
    }
    return isValid;
  }

  void submit() async {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(firstname, lastname, username, email, password);
      }
      final url =
          Uri.parse('https://deco-websocket.onrender.com/users/newUser/');
      final userData = {
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'password': password
      };
      final jsonData = jsonEncode(userData);
      final headers = <String, String>{'Content-Type': 'application/json'};

      final respons = await http.post(url, body: jsonData, headers: headers);

      if (respons.statusCode == 200) {
        _navigateToNewPage();
      } else {
        setState(() {
          signUpError = 'Username already exists';
        });
      }
    }
  }

  void _navigateToNewPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: screenHeight * .03),
              const Center(
                  child: Text(
                'Create User',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78BC3F),
                ),
              )),
              SizedBox(height: screenHeight * .02),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                child: Text('First Name',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF386641),
                    )),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InputField(
                  onChanged: (value) {
                    setState(() {
                      firstname = value;
                    });
                  },
                  onSubmitted: (val) => submit(),
                  errorText: firstnameError,
                  textInputAction: TextInputAction.next,
                  autoFocus: true,
                ),
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                child: Text('Last Name',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF386641),
                    )),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InputField(
                  onChanged: (value) {
                    setState(() {
                      lastname = value;
                    });
                  },
                  onSubmitted: (val) => submit(),
                  errorText: lastnameError,
                  textInputAction: TextInputAction.next,
                  autoFocus: true,
                ),
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                child: Text('Username',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF386641),
                    )),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InputField(
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  onSubmitted: (val) => submit(),
                  errorText: usernameError,
                  textInputAction: TextInputAction.next,
                  autoFocus: true,
                ),
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                child: Text('Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF386641),
                    )),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InputField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  onSubmitted: (val) => submit(),
                  errorText: emailError,
                  textInputAction: TextInputAction.next,
                  autoFocus: true,
                ),
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                child: Text('Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF386641),
                    )),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: InputField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  onSubmitted: (val) => submit(),
                  errorText: passwordError,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  autoFocus: true,
                ),
              )),
              SizedBox(height: screenHeight * .06),
              Center(
                child: SizedBox(
                  width: 220,
                  height: 50,
                  child: SimpleElevatedButton(
                    color: const Color(0xFF78BC3F),
                    onPressed: submit,
                    child: const Text(
                      'Create User',
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Go to log in',
                    style: TextStyle(
                      color: Color(0xFF386641),
                    ),
                  ),
                ),
              ),
              if (signUpError != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      signUpError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
