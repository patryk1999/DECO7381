// ignore: file_namesxw
import 'package:abacusfrontend/mocks/LocationDataMock.dart';
import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:abacusfrontend/pages/summaryScreen.dart';
import 'package:http/http.dart' as http;

class RunScreen extends StatefulWidget {
  const RunScreen({Key? key}) : super(key: key);

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  late GoogleMapController mapController;
  late Position? _previousPosition = null;
  late Position currentPosition;
  late Position? _friendsPreviousPosition = null;
  late Position friendCurrentPosition;
  late bool servicePermission = false;
  late LocationPermission permission;
  late Timer _timer;
  double _frozenDistance = 0;
  double _frozenPace = 0.00;
  bool _isTimerPaused = true;
  double totalDistance = 0;
  int second = 0;
  int minute = 0;
  int hour = 0;
  double friendsTotalDistance = 0;

  double totalDistanceCopy = 0;
  int secondsCopy = 0;
  int minutesCopy = 0;
  int hoursCopy = 0;
  double friendsTotalDistanceCopy = 0;
  final locationDataMock = LocationDataMock();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getMockCurrentLocation();
    _startTimer();
  }

  final List<Position> mockPositions = List.generate(50, (index) {
    final latitude = 40.7128 + (0.0001 * index);
    final longitude = -74.0060 + (0.0001 * index);

    return Position(
      latitude: latitude,
      longitude: longitude,
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      timestamp: DateTime.now().add(const Duration(seconds: 5)),
    );
  });
  int currentIndex = 0;

  Future<int> addRun() async {
    final currentTime = DateTime.now();

    final startTime = currentTime.subtract(
      Duration(
        hours: hour,
        minutes: minute,
        seconds: second,
      ),
    );

    final url = Uri.parse(
        "https://deco-websocket.onrender.com/run/addRun/?startTime=${startTime.toIso8601String()}&avgPace=${_calculatePace(totalDistance)}&endTime=${currentTime.toIso8601String()}");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LoginScreen.accessToken}',
    };

    final response = await http.post(url, headers: headers);

    return response.statusCode;
  }

  Future<void> _getMockCurrentLocation() async {
    final position = mockPositions[currentIndex];

    if (_friendsPreviousPosition != null) {
      final distance = Geolocator.distanceBetween(
        _friendsPreviousPosition!.latitude,
        _friendsPreviousPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      setState(() {
        friendsTotalDistance += distance;
      });
    }

    setState(() {
      friendCurrentPosition = position;
      _friendsPreviousPosition = position;
    });

    currentIndex++;
    Future.delayed(const Duration(seconds: 5), _getMockCurrentLocation);
  }

  Future<void> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      if (kDebugMode) {
        print("service disabled");
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream().listen((position) {
      if (_previousPosition != null) {
        final distance = Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        setState(() {
          totalDistance += distance;
        });
      }

      setState(() {
        currentPosition = position;
        _previousPosition = position;
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null && !_isTimerPaused) {
      _timer.cancel();
      _isTimerPaused = true;
      _frozenDistance = totalDistance;
      _frozenPace = _calculatePace(totalDistance);
    }
  }

  double _calculatePace(double totalDistance) {
    if (totalDistance > 0) {
      final double kilometers = totalDistance / 1000;
      final double hours = hour + minute / 60 + second / 3600;
      final double pace = hours > 0 ? kilometers / hours : 0;
      final formattedPace = pace.toStringAsFixed(1);
      return double.parse(formattedPace);
    } else {
      return 0.0;
    }
  }

  void _resetRunData() {
    totalDistance = 0;
    second = 0;
    minute = 0;
    hour = 0;
    friendsTotalDistance = 0;
    _pauseTimer();
  }

  void _finishRun() {
    addRun();
    totalDistanceCopy = totalDistance;
    friendsTotalDistanceCopy = friendsTotalDistance;
    hoursCopy = hour;
    minutesCopy = minute;
    secondsCopy = second;
    _resetRunData();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SummaryScreen(
                  totalDistance: totalDistanceCopy,
                  hours: hoursCopy,
                  minutes: minutesCopy,
                  seconds: secondsCopy,
                  friendsTotalDistance: friendsTotalDistanceCopy,
                )));
  }

  void _startTimer() {
    if (_isTimerPaused) {
      totalDistance = _frozenDistance;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          second++;
          if (second == 60) {
            second = 0;
            minute++;
            if (minute == 60) {
              minute = 0;
              hour++;
            }
          }
        });
      });
      _isTimerPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Run",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFFFFFFF),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Color(0xFF78BC3F),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xFF78BC3F),
                          width: 5,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      child: GoogleMap(
                          onMapCreated: (controller) {
                            setState(() {
                              mapController = controller;
                            });
                          },
                          initialCameraPosition: CameraPosition(
                            // ignore: unnecessary_null_comparison
                            target: currentPosition != null
                                ? LatLng(currentPosition.latitude,
                                    currentPosition.longitude)
                                : const LatLng(0, 0),
                            zoom: 15.0,
                          ),
                          markers: {
                            Marker(
                                markerId:
                                    const MarkerId('currentLocationMarker'),
                                position: LatLng(currentPosition.latitude,
                                    currentPosition.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen)),
                          }),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    child: GoogleMap(
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: friendCurrentPosition != null
                              ? LatLng(friendCurrentPosition.latitude,
                                  friendCurrentPosition.longitude)
                              : const LatLng(0, 0),
                          zoom: 15.0,
                        ),
                        markers: {
                          Marker(
                              markerId:
                                  const MarkerId('friendCurrentLocationMarker'),
                              position: LatLng(friendCurrentPosition.latitude,
                                  friendCurrentPosition.longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue)),
                        }),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xFF78BC3F),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 30,
                          color: const Color(0xFF78BC3F),
                          child:
                              const Text("You", style: TextStyle(fontSize: 24)),
                        ),
                        const Text(
                          "Time",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 34),
                        ),
                        const Text(
                          "Distance",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          _isTimerPaused
                              ? '${(_frozenDistance / 1000).toStringAsFixed(2)} km'
                              : '${(totalDistance / 1000).toStringAsFixed(2)} km',
                          style: const TextStyle(fontSize: 34),
                        ),
                        const Text(
                          "Average Pace",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          _isTimerPaused
                              ? "${_frozenPace.toStringAsFixed(2)} km/h"
                              : "${_calculatePace(totalDistance)} km/h",
                          style: const TextStyle(fontSize: 34),
                        ),
                        Row(children: [
                          const SizedBox(
                            width: 30,
                            height: 80,
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF78BC3F),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: RawMaterialButton(
                                  shape: const CircleBorder(),
                                  onPressed: () {
                                    if (_isTimerPaused) {
                                      _startTimer();
                                    } else {
                                      _pauseTimer();
                                    }
                                  },
                                  child: _isTimerPaused
                                      ? const Icon(Icons.play_arrow,
                                          size: 30, color: Colors.white)
                                      : const Icon(Icons.pause,
                                          size: 30, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF78BC3F),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: RawMaterialButton(
                                  shape: const CircleBorder(),
                                  onPressed: () {
                                    _finishRun();
                                  },
                                  child: const Center(
                                    child: Text(
                                      "FINISH",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 30,
                        color: const Color(0xFF78BC3F),
                        child: const Text("Friend",
                            style: TextStyle(fontSize: 24)),
                      ),
                      const Text(
                        "Time",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 34),
                      ),
                      const Text(
                        "Distance",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${(friendsTotalDistance != null ? (friendsTotalDistance / 1000).toStringAsFixed(2) : "0.00")} km',
                        style: TextStyle(fontSize: 34),
                      ),
                      const Text(
                        "Average Pace",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "${_calculatePace(friendsTotalDistance)} km/h",
                        style: TextStyle(fontSize: 34),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 80)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
