import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPressed;
  final TextButton firstButton;
  final TextButton secondButton;

  const CustomAppBar({
    required this.title,
    this.onPressed,
    required this.firstButton,
    required this.secondButton,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF78BC3F),
            ),
            onPressed: () {},
            child: const Icon(
              Icons.search,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.black)),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF78BC3F),
            ),
            onPressed: () {},
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
