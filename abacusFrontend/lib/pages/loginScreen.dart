// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:abacusfrontend/pages/homeScreen.dart';
import 'package:abacusfrontend/pages/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:abacusfrontend/components/input_field.dart';
import '../components/simple_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  final Function(String? username, String? password)? onSubmitted;
  const LoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  static String? accesToken;
  static String? refreshToken;
  static String username = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String username, password;
  String? usernameError, passwordError, loginError;
  Function(String? username, String? password)? get onSubmitted =>
      widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    username = '';
    password = '';
    usernameError = null;
    passwordError = null;
    loginError = null;
  }

  bool validate() {
    setState(() {
      usernameError = null;
      passwordError = null;
      loginError = null;
    });

    bool isValid = true;
    if (username.isEmpty) {
      setState(() {
        usernameError = 'Username is invalid';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() async {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(username, password);
      }
      final url = Uri.parse('http://127.0.0.1:8000/users/api/token/');
      final userData = {
        'username': username,
        'password': password,
      };
      final jsonData = jsonEncode(userData);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(url, body: jsonData, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> tokenData = json.decode(response.body);
        LoginScreen.accesToken = tokenData['access'];
        LoginScreen.refreshToken = tokenData['refresh'];
        LoginScreen.username = username;
        _navigateToNewPage();
      } else {
        setState(() {
          loginError = 'The user does not exist or the password is incorrect';
        });
      }
    }
  }

  void _navigateToNewPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        // Wrap everything in a Center widget
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            shrinkWrap: true, // Allow the ListView to shrink-wrap its contents
            children: [
              Image.asset('assets/Rwf.png', width: 180, height: 180),
              SizedBox(height: screenHeight * .03),
              const Center(
                  child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78BC3F),
                ),
              )),
              SizedBox(height: screenHeight * .03),
              const Padding(
                padding: EdgeInsets.only(left: 50.0, bottom: 10),
                child: Text('Username'),
              ),
              Center(
                child: SizedBox(
                  width: 280,
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
                ),
              ),
              SizedBox(height: screenHeight * .03),
              const Padding(
                padding: EdgeInsets.only(left: 50.0, bottom: 10),
                child: Text('Password'),
              ),
              Center(
                child: SizedBox(
                  width: 280,
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
                ),
              ),
              SizedBox(height: screenHeight * .05),
              Align(
                alignment: Alignment.center,
                child: Center(
                    child: SizedBox(
                  width: 200,
                  height: 50,
                  child: SimpleElevatedButton(
                    color: const Color(0xFF78BC3F),
                    onPressed: () {
                      submit();
                    },
                    child: const Text(
                      'Log In',
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                    ),
                  ),
                )),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'Create a new user',
                    style: TextStyle(
                      color: Color(0xFF386641),
                    ),
                  ),
                ),
              ),
              if (loginError != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    loginError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
