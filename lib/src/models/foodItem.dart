import 'package:flutter/material.dart';

class FoodItem {
  final String foodId;
  final String restaurantId;
  final String description;
  final String image;

  FoodItem(
      {@required this.foodId,
        this.restaurantId,
        this.description,
        this.image});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodId: json['foodId'],
      restaurantId: json['restaurantId'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'restaurantId': restaurantId,
      'description': description,
      'image': image,
    };
  }
}