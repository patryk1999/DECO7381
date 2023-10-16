import 'package:abacusfrontend/components/home_card.dart';
import 'package:flutter/material.dart';
import '../components/app_bar.dart';


void main() {
  runApp(
    const HomeScreen(
      homeCardsData: [
        {
          'firstName': 'Elin',
          'lastName': 'Bartnes',
          'username': 'ElinBart',
          'time': '00:06:23',
          'distance': '5,54',
          'avgPace': '6,32',
        },
        {
          'firstName': 'Selma',
          'lastName': 'Gudmundsen',
          'username': 'SelmGud',
          'time': '00:08:15',
          'distance': '3.78 km',
          'avgPace': '4.58 km/h',
        },
      ],
    ),
  );
}
class HomeScreen extends StatelessWidget {
  final List<Map<String, String>>? homeCardsData;
  const HomeScreen({Key? key, this.homeCardsData}) : super(key: key);
  

  

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
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: HomeCard(
                    key: UniqueKey(),
                    firstname: "Elin",
                    lastname: 'Bartnes',
                    username:'EliBart',
                    time: '00:06:23',
                    distance: '5,54',
                    averagePace: '6,32',
                  ),
                ),
              ],
           ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF78BC3F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                color:  Color(0xFF386641),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Join Run',
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                        const SizedBox( 
                        width: 20),
                      Expanded(
                        child: ElevatedButton(
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
                          child: const Text(
                            'Create Run',
                            style: TextStyle(
                                fontSize: 20, fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
