// ignore: file_names
import 'package:flutter/material.dart';
import 'package:abacusfrontend/components/inputField.dart';
import '../components/simpleElevatedButton.dart';

class LoginScreen extends StatefulWidget {
  final Function(String? username, String? password)? onSubmitted;
  const LoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String username, password;
  String? usernameError, passwordError;
  Function(String? username, String? password)? get onSubmitted =>
      widget.onSubmitted;
  @override
  void initState() {
    super.initState();
    username = '';
    password = '';
    usernameError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      usernameError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

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

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(username, password);
      }
    }
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
              Center(
                  child: const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78BC3F),
                ),
              )),
              SizedBox(height: screenHeight * .03),
              Padding(
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
              Padding(
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
              Center(
                  child: SizedBox(
                width: 200,
                height: 50,
                child: SimpleElevatedButton(
                  color: Color(0xFF78BC3F),
                  onPressed: submit,
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                  ),
                ),
              )),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Create a new user',
                    style: TextStyle(
                      color: Color(0xFF386641),
                    ),
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
