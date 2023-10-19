import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final TextButton firstButton;

  const CustomAppBar({
    required this.title,
    required this.firstButton,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          firstButton,
          Flexible(
            child: Text(
              title,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.settings, color: Color(0xFF78BC3F)),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Settings'),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Sign Out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
