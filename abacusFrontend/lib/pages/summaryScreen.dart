import 'package:flutter/material.dart';
import '../components/app_bar.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppBarExample(),
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextButton firstButton = TextButton(
      style: TextButton.styleFrom(
        primary: const Color(0xFF78BC3F),
      ),
      onPressed: () {},
      child: const Icon(Icons.arrow_back_ios),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Summary',
        firstButton: firstButton,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
