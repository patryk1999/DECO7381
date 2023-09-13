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
      child: const Icon(Icons.search),
    );

    TextButton secondButton = TextButton(
      style: TextButton.styleFrom(
        primary: const Color(0xFF78BC3F),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
            child: Center(
              child: Text(
                "Hey friend, welcome back! Ready to run today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78BC3F),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          Image.asset('assets/lizard.webp', width: 180, height: 180),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: double.infinity,
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
                                color: const Color(0xFF386641),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Join Run',
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF78BC3F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: const Color(0xFF386641),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Create Run',
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
