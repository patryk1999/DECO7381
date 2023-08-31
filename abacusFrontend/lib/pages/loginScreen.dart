import 'package:flutter/material.dart';

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

class SimpleElevatedButton extends StatelessWidget {
  const SimpleElevatedButton(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 30,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return FilledButton(
      style: FilledButton.styleFrom(
          padding: padding,
          shadowColor: Color(0x000000),
          backgroundColor: color ?? currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          side: BorderSide(
            color: Colors.black,
          )),
      onPressed: onPressed as void Function()?,
      child: child,
    );
  }
}

class InputField extends StatelessWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final String? errorText;
  final bool obscureText;
  const InputField(
      {this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      this.obscureText = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(50), // Always use borderRadius of 50
        ),
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF78BC3F)),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.blue), // Change border color here
        ),

        isDense: true, // To make the content centered
      ),
    );
  }
}
