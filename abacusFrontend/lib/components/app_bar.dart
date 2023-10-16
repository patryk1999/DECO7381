import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPressed;
  final TextButton firstButton;
  final TextButton? secondButton;

  const CustomAppBar({
    required this.title,
    this.onPressed,
    required this.firstButton,
    this.secondButton,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          firstButton,
          Text(title, style: TextStyle(color: Colors.black)),
          secondButton ??
              Opacity(
                opacity: 0.0,
                child: TextButton(
                  onPressed:
                      () {}, // empty onPressed so the button is "inactive"
                  child:
                      Text('texting'), // A placeholder text, it'll be invisible
                ),
              ),
        ],
      ),
    );
  }
}
