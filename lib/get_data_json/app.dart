import 'package:flutter/material.dart';
import 'page_home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get data JSON',
      home: HomePage(),
    );
  }
}