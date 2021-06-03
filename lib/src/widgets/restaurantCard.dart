import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantCard({this.restaurant});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
