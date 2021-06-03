import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:foodstack/src/widgets/header.dart';

class MenuScreen extends StatefulWidget {
  Restaurant restaurant;

  MenuScreen({this.restaurant});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(title: widget.restaurant.restaurantName),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        children: [
          FoodCard(),
          FoodCard(),
          FoodCard(),
          FoodCard(),
        ],

      )
    );
  }
}
