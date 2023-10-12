// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abacusfrontend/pages/runScreen.dart';
import 'package:flutter/material.dart';
import '../components/app_bar.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late double distance = RunScreen.totalDistance;
  late int hours = RunScreen.hours;
  late int minutes = RunScreen.minutes;
  late int seconds = RunScreen.seconds;
  late double pace = calculatePace(hours, minutes, seconds, distance);

  late double friendDistance = 1.24;
  late int friendHours = 00;
  late int friendMinutes = 06;
  late int friendSeconds = 45;
  late double friendPace =
      calculatePace(friendHours, friendMinutes, friendSeconds, friendDistance);

  double calculatePace(int hours, int minutes, int seconds, double distance) {
    double totalHours = hours + (minutes / 60.0) + (seconds / 3600.0);
    double pace = distance / totalHours;
    return pace;
  }

  String padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  bool isHigher(double you, double friend) {
    if (you > friend) {
      return true;
    } else {
      return false;
    }
  }

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
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 30.0),
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
                SizedBox(height: 20),
                Text(
                  "Time",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF386641),
                  ),
                ),
                Text(
                  '${padZero(hours)}:${padZero(minutes)}:${padZero(seconds)}',
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
                SizedBox(height: 20),
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
                              "${(distance).toStringAsFixed(2)} km",
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
                              "Average Pace",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            Text(
                              "${(pace).toStringAsFixed(2)} km/h",
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
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 30.0),
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
                SizedBox(height: 20),
                Container(
                    width: 150,
                    child: isHigher(friendPace, pace)
                        ? Text(
                            "You’re getting there",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF386641),
                              letterSpacing: 1.2,
                            ),
                          )
                        : Text(
                            "You’re the fastest",
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
                SizedBox(height: 20),
                Text(
                  "Runner 1",
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
                SizedBox(height: 10),
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
                            isHigher(distance, friendDistance)
                                ? Text(
                                    "-${(distance - friendDistance).toStringAsFixed(2)} km",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFF78BC3F),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Text(
                                    "+${(friendDistance - distance).toStringAsFixed(2)} km",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFFBC3F3F),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average Pace",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            isHigher(pace, friendPace)
                                ? Text(
                                    "-${(pace - friendPace).toStringAsFixed(2)} km/h",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFF78BC3F),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Text(
                                    "+${(friendPace - pace).toStringAsFixed(2)} km/h",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 29,
                                      color: Color(0xFFBC3F3F),
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
