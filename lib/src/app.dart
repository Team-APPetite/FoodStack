import 'package:flutter/material.dart';
import 'package:foodstack/src/app_providers/userLocator.dart';
import 'package:foodstack/src/screens/login.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserLocator(),
      child: MaterialApp(
        title: 'FoodStack',
        home: LoginScreen(),
      ),
    );
  }
}
