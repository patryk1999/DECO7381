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
        primary: const Color(0xFF78BC3F), // Use primary for text color
      ),
      onPressed: () {},
      child: const Icon(Icons.search),
    );

    TextButton secondButton = TextButton(
      style: TextButton.styleFrom(
        primary: const Color(0xFF78BC3F), // Use primary for text color
      ),
      onPressed: () {},
      child: const Icon(Icons.settings),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        firstButton: firstButton,
        secondButton: secondButton,
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: double.infinity, // Use maximum width
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF78BC3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: const Color(0xFF386641), // Set border color
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 13), // Increase button height
                    ),
                    onPressed: () {},
                    child: Text(
                      'Join Run',
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Add spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF78BC3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: const Color(0xFF386641), // Set border color
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 13), // Increase button height
                    ),
                    onPressed: () {},
                    child: Text(
                      'Create Run',
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
