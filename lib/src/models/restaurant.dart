import 'package:flutter/material.dart';

class Restaurant {
  final String restaurantId;
  final String restaurantName;
  final String cuisineType;
  final int deliveryMins;
  final double rating;
  final String image;

  Restaurant(
      {@required this.restaurantId,
      this.restaurantName,
      this.cuisineType,
      this.deliveryMins,
      this.rating,
      this.image});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      cuisineType: json['cuisineType'],
      deliveryMins: json['deliveryMins'],
      rating: json['rating'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'cuisineType': cuisineType,
      'deliveryMins': deliveryMins,
      'rating': rating,
      'image': image,
    };
  }
}
