import 'package:flutter/material.dart';

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
              BorderRadius.circular(5), // Always use borderRadius of 50
        ),
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF78BC3F)),
        ),

        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.blue), // Change border color here
        ),

        isDense: true, // To make the content centered
      ),
    );
  }
}
