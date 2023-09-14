import 'package:flutter/material.dart';
import '../components/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  // This controller will store the value of the search bar
  final TextEditingController _searchController = TextEditingController();

  List<User> friends = [
    const User(
        name: 'Elin Bartnes',
        username: 'bartnese',
        email: 'elin.bartnes@mail.com',
        initials: 'EB'),
    const User(
        name: 'Thea Salvesen',
        username: 'thesasa',
        email: 'thea.salvesen@mail.com',
        initials: 'TS'),
    const User(
        name: 'Emilie Frohaug',
        username: 'emilifr',
        email: 'emilie.frohaug@mail.com',
        initials: 'EF'),
    const User(
        name: 'Selma Gudmundsen',
        username: 'selmag',
        email: 'selma.gudmundsen@mail.com',
        initials: 'SG'),
    const User(
        name: 'Tord Gunnarsli',
        username: 'tordsg',
        email: 'tord.gunnarsli@mail.com',
        initials: 'TG'),
    const User(
        name: 'Patryk Kuklinski',
        username: 'patrykk',
        email: 'elin.bartnes@mail.com',
        initials: 'PK'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.all(8.0)),
            Container(
              // Add padding around the search bar
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              // Use a Material design search bar
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  // Add a clear button to the search bar
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  ),
                  // Add a search icon or button to the search bar
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // showSearch(
                      //     context: context,
                      //     // delegate to customize the search bar
                      //     delegate: CustomSearchDelegate());
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];

                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.green,
                            child: Text('AB')),
                        title: Text(friend.name),
                        subtitle: Text(friend.username),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   // first overwrite to
//   // clear the search text
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(Icons.clear),
//       ),
//     ];
//   }

//   // second overwrite to pop out of search menu
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var friend in friends) {
//       if (friend.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(friend);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for (var friend in friends) {
//       if (friend.toLowerCase().contains(query.toLowerCase())) {
//         matchQuery.add(friend);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
