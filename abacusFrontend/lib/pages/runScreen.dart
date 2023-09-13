import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class RunScreen extends StatefulWidget {
  const RunScreen({Key? key}) : super(key: key);

  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  late GoogleMapController mapController;
  late Position? _previousPosition;
  late Position currentPosition;
  late double _totalDistance = 0;
  late bool servicePermission = false;
  late LocationPermission permission;
  late Timer _timer;
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  bool _isTimerPaused = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTimer();
  }

  Future<void> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if (_previousPosition != null) {
      final distance = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      _totalDistance += distance;
    }
    setState(() {
      currentPosition = position;
      _previousPosition = position;
    });
  }

  void _pauseTimer() {
    if (_timer != null && !_isTimerPaused) {
      _timer.cancel();
      _isTimerPaused = true;
    }
  }

  String _calculatePace() {
    if (_totalDistance > 0) {
      final double kilometers = _totalDistance / 1000;
      final double hours = _hours + _minutes / 60 + _seconds / 3600;
      final double pace = hours > 0 ? kilometers / hours : 0;
      return pace.toStringAsFixed(2) + ' km/h'; // Format pace as "X.XX km/h"
    } else {
      return '0.00 km/h';
    }
  }

  void _startTimer() {
    if (_isTimerPaused) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
          if (_seconds == 60) {
            _seconds = 0;
            _minutes++;
            if (_minutes == 60) {
              _minutes = 0;
              _hours++;
            }
          }
        });
      });
      _isTimerPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              // Add your settings button action here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // First row
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
                        target: LatLng(
                          currentPosition.latitude,
                          currentPosition.longitude,
                        ),
                        zoom: 15.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
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
                      target: LatLng(
                        currentPosition.latitude,
                        currentPosition.longitude,
                      ),
                      zoom: 15.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
              ),
            ],
          ),
          // Second row
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
                        '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 34),
                      ),
                      const Text(
                        "Distance",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${(_totalDistance / 1000).toStringAsFixed(2)} km', // Convert to kilometers and format
                        style: TextStyle(fontSize: 34),
                      ),
                      const Text(
                        "Average Pace",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        _calculatePace(), // Convert to kilometers and format
                        style: TextStyle(fontSize: 34),
                      ),
                      Row(children: [
                        SizedBox(width: 30),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF78BC3F),
                          ),
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 30,
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
                                    ? Icon(Icons.play_arrow,
                                        size: 30, color: Colors.white)
                                    : Icon(Icons.pause,
                                        size: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF78BC3F),
                          ),
                          child: const Center(
                            child: Text(
                              "FINISH",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ])
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
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
                      const Text("00:00:00", style: TextStyle(fontSize: 34)),
                      const Text(
                        "Distance",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Text("1.36 km", style: TextStyle(fontSize: 34)),
                      const Text(
                        "Average Pace",
                        style: TextStyle(fontSize: 18),
                      ),
                      const Text("9.56 km/t", style: TextStyle(fontSize: 34)),
                      SizedBox(width: 70, height: 70)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
