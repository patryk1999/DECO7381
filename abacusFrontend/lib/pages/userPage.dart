import 'package:flutter/material.dart';
import '../components/user.dart';

class UserPage extends StatelessWidget {
  final User user;

  const UserPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(user.name,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ))
        ]),
      ));
}
