
import 'dart:convert';

import 'package:abacusfrontend/components/home_card.dart';
import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:abacusfrontend/pages/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../components/app_bar.dart';
import 'runScreen.dart';
import 'package:http/http.dart' as http; // Import the RunScreen



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> runHistoryList = [];
  String firstname = "";
  String lastname = "";
  String username = "";
  String otheruser = "";

  @override
  void initState() {
    super.initState();
    fetchRunHistory();
    fetchUserData();
  }
  

  Future<List<Map<String, dynamic>>> fetchRunHistory() async {
    final accessToken = LoginScreen.accessToken;
    final uri = Uri.parse('https://deco-websocket.onrender.com/run/getHistory');
    final headers = {'Authorization': 'Bearer $accessToken'};

    final response = await http.get(uri, headers: headers);
    if(response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final runHistory = List<Map<String, dynamic>>.from(jsonResponse.values);

      return runHistory;
    } else {
      throw Exception('Failed to load run history');
      //handle error
     // print(response.statusCode);
    }
}

Future<void> fetchUserData() async {
    final accessToken = LoginScreen.accessToken;
    final uri = Uri.parse('https://deco-websocket.onrender.com/users/getMyData/');
    final headers = {'Authorization': 'Bearer $accessToken'};

    final response = await http.get(uri, headers: headers);
    if(response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      setState((){
        firstname = jsonResponse['firstName'];
        lastname = jsonResponse['lastName'];
        username = jsonResponse['username'];
      });
    } else {
      //handle error 
      //print(response.statusCode);
    }
}



String calculateRunTime(String startTime, String endTime) {
  DateTime start = DateTime.parse(startTime);
  DateTime end = DateTime.parse(endTime);

  int differenceInSeconds = end.difference(start).inSeconds;
  int hours = differenceInSeconds ~/ 3600;
  int minutes = (differenceInSeconds % 3600) ~/ 60;
  int seconds = differenceInSeconds % 60;

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
  String calculateDistance(String startTime, String endTime, double averagePace) {
    DateTime start = DateTime.parse(startTime);
    DateTime end = DateTime.parse(endTime);

    int differenceInSeconds = end.difference(start).inSeconds;

    double distance = (differenceInSeconds / 3600) * averagePace;
    distance = double.parse(distance.toStringAsFixed(2));
    return distance.toString();
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    final servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service disabled");
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied) {
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RunScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: const CustomAppBar(
          title: 'Home',
          firstButton: TextButton(
            onPressed: null,
            child: Icon(Icons.search),
          ),
          secondButton: TextButton(
            onPressed: null,
            child: Icon(Icons.settings),
          )),
      body: Stack(
        children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchRunHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading data"),
                  );
                } else {
                  final runHistoryList = snapshot.data;

                  if (runHistoryList == null || runHistoryList.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Welcome to Run with Friends!",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF78BC3F),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Start a run or join a friend's run to get started on your global running journey.",
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              color: Color(0xFF386641),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/lizard.webp',
                          width: 180,
                          height: 180,
                        ),
                      ],
                    );
                  } else {
                    return ListView(
                      children: [
                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: runHistoryList.length,
                              itemBuilder: (context, index) {
                                final runHistory = runHistoryList[index];
                                return HomeCard(
                                  firstname: firstname,
                                  lastname: lastname,
                                  username: username,
                                  otheruser: runHistory['runFriend'] ?? "Pat",
                                  time: calculateRunTime(runHistory['startTime'], runHistory['endTime']),
                                  distance: calculateDistance(runHistory['startTime'], runHistory['endTime'], runHistory['avgPace']),
                                  averagePace: runHistory['avgPace'].toString(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF78BC3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Color(0xFF386641),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () {
                      _requestLocationPermission(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                    child:  const Text(
                      'Join Run',
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                      ),
                      ),
                    ),
                  ),                 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF78BC3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Color(0xFF386641),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()),
                            );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      'Create Run',
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      ),
    );
  }
}