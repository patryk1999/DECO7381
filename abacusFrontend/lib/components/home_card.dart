import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String username;
  final String time;
  final String distance;
  final String averagePace;


  const HomeCard({
    Key? key,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.time,
    required this.distance,
    required this.averagePace,
  }): super(key: key);



  @override
  Widget build(BuildContext context) {

    final String initials= (firstname.isNotEmpty && lastname.isNotEmpty)
        ? firstname[0].toUpperCase() + lastname[0].toUpperCase()
        : '';
    final name = "$firstname $lastname";

    return Center(
        child: Padding(
            padding:const EdgeInsets.only(top: 20),
            child: Card(
                color: const Color(0xFFF4FFF0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: SizedBox(
                    width: 450,
                    height: 180,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                                Column(
                                  children: [
                                    Padding(padding: const EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: const  Color(0xFF78BC3F),
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        )
                                      )
                                    )
                                  ]
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                      name,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                              ]
                            ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Did a run with $username",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color:  Color(0xFF386641),
                                    ),
                                  ),
                                ),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   const Text(
                                      "Time",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF386641),
                                      ),
                                    ),
                                    Text(
                                      time,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    )
                                  ]),
                              const SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: Color(0xFF78BC3F),
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Distance",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF386641),
                                      ),
                                    ),
                                    Text(
                                      "$distance km",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    )
                                  ]),
                              const SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: Color(0xFF78BC3F),
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Average Pace",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF386641),
                                      ),
                                    ),
                                    Text(
                                      "$averagePace km/h",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    )
                                  ])
                            ],
                          ),
                        ])))));
  }
}
