import 'package:flutter/material.dart';

class FoodItem {
  final String foodId;
  final String foodName;
  final String description;
  final double price;
  final String image;

  FoodItem(
      {@required this.foodId,
        this.foodName,
        this.description,
        this.price,
        this.image});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodId: json['foodId'],
      foodName: json['foodName'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}