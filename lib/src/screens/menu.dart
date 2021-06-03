import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/widgets/header.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(title: restaurant.restaurantName),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        children: [

        ],

      )
    );
  }
}
