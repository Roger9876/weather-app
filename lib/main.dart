import 'package:flutter/material.dart';
import 'package:mp5/views/search_page.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(MaterialApp(
    title: 'Weather App',
    home: const SearchPage(),
    debugShowCheckedModeBanner: false,
  ));
}
