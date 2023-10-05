// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../components/app_bar.dart';

void main() => runApp(const SummaryScreen());

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

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
        children: [
          Container(
            margin: EdgeInsets.all(20),
            color: Color(0xFFF4FFF0),
            padding: const EdgeInsets.fromLTRB(30.0, 16.0, 16.0, 30.0),
            // ignore: prefer_const_constructors
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Your Run",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF78BC3F),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 20), // Space between the texts
                Text(
                  "Time", // Your additional text
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF386641),
                  ),
                ),
                Text(
                  "00:06:45",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Divider(
                  color: Color(0xFF78BC3F),
                  thickness: 1,
                  indent: 60,
                  endIndent: 60,
                ),
                SizedBox(height: 20), // Space between the texts
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Distance",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            Text(
                              "1,36 km", // Your additional text
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78BC3F),
                              thickness: 1,
                              indent: 0,
                              endIndent: 30,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average Pace", // Your additional text
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            Text(
                              "9,58 km/t", // Your additional text
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Divider(
                              color: Color(0xFF78BC3F),
                              thickness: 1,
                              indent: 0,
                              endIndent: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            color: Color(0xFFF4FFF0),
            padding: const EdgeInsets.fromLTRB(30.0, 16.0, 16.0, 30.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Run Duel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF78BC3F),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 20), // Space between the texts
                Container(
                    width: 150,
                    child: Text(
                      "You’re getting there",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF386641),
                        letterSpacing: 1.2,
                      ),
                    )),
                Divider(
                  color: Color(0xFF78BC3F),
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                ),
                SizedBox(height: 20), // Space between the texts
                Text(
                  "Runner 1", // Your additional text
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF386641),
                  ),
                ),
                Divider(
                  color: Color(0xFF78BC3F),
                  thickness: 1,
                ),
                SizedBox(height: 10), // Space between the texts
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Distance", // Your additional text
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            Text(
                              "1,36 km", // Your additional text
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average Pace", // Your additional text
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            Text(
                              "9,58 km/t", // Your additional text
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
