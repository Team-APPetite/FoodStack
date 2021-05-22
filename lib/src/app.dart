import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodStack',
      home: LoginScreen(),
    );
  }
}
