import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({Key? key}) : super(key: key);

  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  late GoogleMapController mapController;
  late Position currentPosition;
  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
    setState(() {
      currentPosition = position;
    });
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
                      Row(children: [
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
                            color: Colors.white,
                            child: RawMaterialButton(
                              shape: const CircleBorder(),
                              onPressed: () {},
                            ),
                          )),
                        ),
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
