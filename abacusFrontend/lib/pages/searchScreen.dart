// ignore_for_file: avoid_print

import 'package:abacusfrontend/main.dart';
import 'package:flutter/material.dart';
import 'package:abacusfrontend/pages/searchScreen.dart';

class Friend implements Comparable<Friend> {
  final String name, surname, email;

  const Friend(this.name, this.surname, this.email)

  @override
  int compareTo(Friend other) => name.compareTo(other.name);

}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchScreen());
  }
}


class SearchScreen extends StatelessWidget {

  static const people = [
    Friend('Thea', 'Salvesen', 'thea@mail.com'),
    Friend('Tord', 'Gunnarsli', 'tord@mail.com'),
    Friend('Elin', 'Bartnes', 'elin@mail.com'),
    Friend('Emilie', 'Frohaug', 'emmi@mail.com'),
  ];

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState => _SearchScreenState();

  class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
}