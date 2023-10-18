
import 'dart:convert';

import 'package:abacusfrontend/components/home_card.dart';
import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator library
import '../components/app_bar.dart';
import 'runScreen.dart';
import 'package:http/http.dart' as http; // Import the RunScreen



class HomeScreen extends StatefulWidget {
    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> runHistoryList = [];

  @override
  void initState() {
    super.initState();

   fetchRunHistory();
  }
  

  Future<void> fetchRunHistory() async {
    final accessToken = LoginScreen.accesToken;
    final uri = Uri.parse('http://127.0.0.1:8000/run/getHistory');
    final headers = {'Authorization': 'Bearer $accessToken'};

    final response = await http.get(uri, headers: headers);
    if(response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final runHistory = List<Map<String, dynamic>>.from(json.decode(response.body).values);

      setState((){
        runHistoryList = runHistory;
      });
      print(runHistoryList);
      print(response.body);
    } else {
      print(response.statusCode);
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
          ListView(
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
                          firstname: 'Elin',
                          lastname: 'Bartnes', 
                          username: 'EliBart', 
                          time: calculateRunTime(runHistory['startTime'], runHistory['endTime']), 
                          distance: calculateDistance(runHistory['startTime'], runHistory['endTime'], runHistory['avgPace']), 
                          averagePace: runHistory['avgPace'].toString(),
                      );
                    },
                  ),
                ],
              ),
            ],
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
                    onPressed: () {},
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