import 'package:abacusfrontend/pages/homeScreen.dart';
import 'package:flutter/material.dart';
import '../components/app_bar.dart';

class SummaryScreen extends StatefulWidget {
  final double totalDistance;
  final int hours;
  final int minutes;
  final int seconds;
  final double friendsTotalDistance;
  const SummaryScreen({
    Key? key,
    required this.totalDistance,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.friendsTotalDistance,
  }) : super(key: key);

  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    pace = calculatePace(
        widget.hours, widget.minutes, widget.seconds, widget.totalDistance);
    friendPace = calculatePace(widget.hours, widget.minutes, widget.seconds,
        widget.friendsTotalDistance);
  }

  late double pace = calculatePace(
      widget.hours, widget.minutes, widget.seconds, widget.totalDistance);

  late double friendDistance = widget.friendsTotalDistance / 1000;
  late int friendHours = widget.hours;
  late int friendMinutes = widget.minutes;
  late int friendSeconds = widget.seconds;
  late double friendPace =
      calculatePace(friendHours, friendMinutes, friendSeconds, friendDistance);

  double calculatePace(int hours, int minutes, int seconds, double distance) {
    double totalHours = hours + (minutes / 60.0) + (seconds / 3600.0);
    double pace = distance / (totalHours * 1000);
    return pace;
  }

  @override
  Widget build(BuildContext context) {
    TextButton firstButton = TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF78BC3F),
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      child: const Icon(Icons.home),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Summary',
        firstButton: firstButton,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            color: const Color(0xFFF4FFF0),
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Your Run",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF78BC3F),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Time",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF386641),
                  ),
                ),
                Text(
                  '${widget.hours.toString().padLeft(2, '0')}:${widget.minutes.toString().padLeft(2, '0')}:${widget.seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Divider(
                  color: Color(0xFF78BC3F),
                  thickness: 1,
                  indent: 60,
                  endIndent: 60,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Distance",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            Text(
                              "${(widget.totalDistance / 1000).toStringAsFixed(2)} km",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Divider(
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
                            const Text(
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
                              style: const TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Divider(
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
            margin: const EdgeInsets.all(16),
            color: const Color(0xFFF4FFF0),
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 30.0),
            child: Column(
              children: [
                const Text(
                  "Run Duel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF78BC3F),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: 150,
                    child: friendPace > pace
                        ? const Text(
                            "You’re getting there",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF386641),
                              letterSpacing: 1.2,
                            ),
                          )
                        : const Text(
                            "You’re the fastest",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF386641),
                              letterSpacing: 1.2,
                            ),
                          )),
                const Divider(
                  color: Color(0xFF78BC3F),
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Runner 1",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF386641),
                  ),
                ),
                const Divider(
                  color: Color(0xFF78BC3F),
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Distance",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            widget.totalDistance > friendDistance
                                ? Text(
                                    "-${((widget.totalDistance - friendDistance) / 1000).toStringAsFixed(2)} km",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFF78BC3F),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Text(
                                    "+${((friendDistance - widget.totalDistance) / 1000).toStringAsFixed(2)} km",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
                            const Text(
                              "Average Pace",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF386641),
                              ),
                            ),
                            pace > friendPace
                                ? Text(
                                    "-${(pace - friendPace).toStringAsFixed(2)} km/h",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFF78BC3F),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Text(
                                    "+${(friendPace - pace).toStringAsFixed(2)} km/h",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
