import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:abacusfrontend/pages/summaryScreen.dart';

class RunScreen extends StatefulWidget {
  static double totalDistance = 0;
  static int seconds = 0;
  static int minutes = 0;
  static int hours = 0;

  const RunScreen({Key? key}) : super(key: key);

  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  late GoogleMapController mapController;
  late Position? _previousPosition = null;
  late Position currentPosition;
  late bool servicePermission = false;
  late LocationPermission permission;
  late Timer _timer;
  double _frozenDistance = 0;
  String _frozenPace = '0.00 km/h';
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
    Geolocator.getPositionStream().listen((position) {
      if (_previousPosition != null) {
        final distance = Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        setState(() {
          RunScreen.totalDistance += distance;
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
      _frozenDistance = RunScreen.totalDistance;
      _frozenPace = _calculatePace();
    }
  }

  String _calculatePace() {
    if (RunScreen.totalDistance > 0) {
      final double kilometers = RunScreen.totalDistance / 1000;
      final double hours =
          RunScreen.hours + RunScreen.minutes / 60 + RunScreen.seconds / 3600;
      final double pace = hours > 0 ? kilometers / hours : 0;
      return '${pace.toStringAsFixed(2)} km/h';
    } else {
      return '0.00 km/h';
    }
  }

  void _finishRun() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SummaryScreen()));
  }

  void _startTimer() {
    if (_isTimerPaused) {
      RunScreen.totalDistance = _frozenDistance;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          RunScreen.seconds++;
          if (RunScreen.seconds == 60) {
            RunScreen.seconds = 0;
            RunScreen.minutes++;
            if (RunScreen.minutes == 60) {
              RunScreen.minutes = 0;
              RunScreen.hours++;
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
            onPressed: () {},
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
                        _isTimerPaused
                            ? '${(_frozenDistance / 1000).toStringAsFixed(2)} km'
                            : '${(RunScreen.totalDistance / 1000).toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 34),
                      ),
                      const Text(
                        "Distance",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${(RunScreen.totalDistance).toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 34),
                      ),
                      const Text(
                        "Average Pace",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        _isTimerPaused ? _frozenPace : _calculatePace(),
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
                            child: Container(
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
                            child: Container(
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
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 80)
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
