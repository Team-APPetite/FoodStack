import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/login.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodStack',
      home: LoginScreen(),
    );
  }
}

