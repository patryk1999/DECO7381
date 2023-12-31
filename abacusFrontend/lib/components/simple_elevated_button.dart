// ignore: file_names
import 'package:flutter/material.dart';

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
          backgroundColor: color ?? currentTheme.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          side: const BorderSide(
            color: Color(0xFF386641),
          )),
      onPressed: onPressed as void Function()?,
      child: child,
    );
  }
}
