import 'dart:convert';

import 'package:abacusfrontend/components/simple_elevated_button.dart';
import 'package:abacusfrontend/pages/loginScreen.dart';
import 'package:flutter/material.dart';
import '../components/user.dart';
import 'package:http/http.dart' as http;

void main() => runApp(SearchScreen(
    accessToken: LoginScreen.accessToken, username: LoginScreen.username));

class SearchScreen extends StatefulWidget {
  final String? accessToken;
  final String? username;
  const SearchScreen({Key? key, this.accessToken, this.username})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _friendSearchController = TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  late AnimationController loadController;
  bool changePage = false;
  List<User> friendsBackend = [];
  List<User> filteredFriends = [];

  List<User> allUsers = [];
  List<User> filteredUsers = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
    _tabController.addListener(_handleTabChange);
    loadController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    loadController.repeat(reverse: true);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        // Fetch data when the "Friends" tab is selected
        fetchData();
      } else if (_tabController.index == 1) {
        // Fetch all users when the "Add Friends" tab is selected
        fetchAllUsers();
      }
    }
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://deco-websocket.onrender.com/users/getFriends/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LoginScreen.accessToken}',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<User> fetchedUsers = [];

      responseData.forEach((userId, userData) {
        if (userData[3] != LoginScreen.username) {
          final User user = User(
            id: userId,
            firstname: userData[0],
            lastname: userData[1],
            email: userData[2],
            username: userData[3],
          );
          fetchedUsers.add(user);
        }
      });

      setState(() {
        friendsBackend = fetchedUsers;
        filteredFriends = fetchedUsers; // Display the fetched data initially
      });
    }
  }

  Future<void> fetchAllUsers() async {
    final url = Uri.parse('https://deco-websocket.onrender.com/users/getAllUsers/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${LoginScreen.accessToken}',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<User> fetUsers = [];

      responseData.forEach((userId, userData) {
        if (userData[3] != LoginScreen.username) {
          final User user = User(
            id: userId,
            firstname: userData[0],
            lastname: userData[1],
            email: userData[2],
            username: userData[3],
          );
          fetUsers.add(user);
        }
      });

      setState(() {
        allUsers = fetUsers;
        filteredUsers = fetUsers; // Display the fetched data initially
      });
    } else {
      // Handle error when the API request fails
      // Show an error message or take other actions here
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    loadController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, display the default friends list
        filteredFriends = friendsBackend;
      } else {
        // Filter the friends list by username
        filteredFriends = friendsBackend
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void filterSearchResultsUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, display the default friends list
        filteredUsers = allUsers;
      } else {
        // Filter the friends list by username
        filteredUsers = allUsers
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<int> addFriend(String? username1) async {
    final url = Uri.parse('https://deco-websocket.onrender.com/users/makeFriend/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.accessToken}',
    };

    final userData = {
      'username_1': username1,
      'username_2': LoginScreen.username,
    };

    final jsonData = jsonEncode(userData);

    final response = await http.post(url, body: jsonData, headers: headers);

    return response.statusCode;
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
          title: Text(
              "Waiting for ${user.firstname} ${user.lastname} to join the run"),
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
          title: Text("""
Do you want to run with ${user.firstname} ${user.lastname}?"""),
          content: const Column(
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

  void _showAddFriendDialog(User user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${user.firstname} ${user.lastname}'),
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
                  onPressed: () async {
                    await addFriend(user.username);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
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
            bottom: TabBar(
              controller: _tabController,
              tabs: const <Widget>[
                Tab(text: "Friends"),
                Tab(text: "Add Friends"),
              ],
            )),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0)),
                  TextField(
                    controller: _friendSearchController,
                    onChanged: filterSearchResults,
                    decoration: InputDecoration(
                      hintText: 'Search for usernames',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _friendSearchController.clear();
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
                                child: Text(getInitials(
                                    '${user.firstname} ${user.lastname}')),
                              ),
                              title: Text('${user.firstname} ${user.lastname}'),
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
                    controller: _userSearchController,
                    onChanged: filterSearchResultsUsers,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _userSearchController.clear();
                          filterSearchResultsUsers('');
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
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return GestureDetector(
                          onTap: () {
                            _showAddFriendDialog(user);
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.green,
                                child: Text(getInitials(
                                    '${user.firstname} ${user.lastname}')),
                              ),
                              title: Text('${user.firstname} ${user.lastname}'),
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
