import 'package:flutter/material.dart';
import 'package:foodstack/src/models/foodItem.dart';

class FoodCard extends StatefulWidget {
  final FoodItem foodItem;

  FoodCard({this.foodItem});

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
