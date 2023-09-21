import 'package:abacusfrontend/components/simple_elevated_button.dart';
import 'package:abacusfrontend/pages/homeScreen.dart';
import 'package:flutter/material.dart';
import '../components/user.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController loadController;
  bool changePage = false;
  late List<User> friendsBackend;

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
    // Add more user data here as needed
  ];

  List<User> filteredFriends = [];

  @override
  Future<void> initState() async {
    super.initState();
    filteredFriends =
        friendsBackend; // Display the default friends list initially
    final url = Uri.parse('http://127.0.0.1:8000/users/getFriends/');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final respons = await http.get(url, headers: headers);
    loadController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    loadController.repeat(reverse: true);
  }

  @override
  void dispose() {
    loadController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, display the default friends list
        filteredFriends = friends;
      } else {
        // Filter the friends list by username
        filteredFriends = friends
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    } else {
      return '';
    }
  }

  void _showLoadRunDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Waiting for ${user.name} to join the run"),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
          ),
          actions: [
            Center(
              child: CircularProgressIndicator(
                value: loadController.value,
                semanticsLabel: 'Circular progress indicator',
              ),
            ),
          ],
        );
      },
    );
  }

  _showCreateRunDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Do you want to run with ${user.name}?"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: SimpleElevatedButton(
                  color: const Color(0xFF78BC3F),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showLoadRunDialog(user);
                  },
                  child: const Text(
                    'Create run',
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddFriendDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Username: ${user.username}"),
              // Add more user information here as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: SimpleElevatedButton(
                  color: const Color(0xFF78BC3F),
                  onPressed: () {
                    //Add person as friend
                  },
                  child: const Text(
                    'Add user as friend',
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Create Run'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: "Friends"),
              Tab(text: "Add Friends"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0)),
                  TextField(
                    controller: _searchController,
                    onChanged: filterSearchResults,
                    decoration: InputDecoration(
                      hintText: 'Search for usernames',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          filterSearchResults('');
                        },
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final user = filteredFriends[index];
                        return GestureDetector(
                          onTap: () {
                            _showCreateRunDialog(user);
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.green,
                                child: Text(getInitials(user.name)),
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.username),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0)),
                  TextField(
                    controller: _searchController,
                    onChanged: filterSearchResults,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          filterSearchResults('');
                        },
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final user = filteredFriends[
                            index]; //filtered friends should be empty when first initiated
                        return GestureDetector(
                          onTap: () {
                            _showAddFriendDialog(user);
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.green,
                                child: Text(getInitials(user.name)),
                              ),
                              title: Text(user.name),
                              subtitle: Text(user.username),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
