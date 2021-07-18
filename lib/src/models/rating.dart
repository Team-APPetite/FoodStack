import 'package:flutter/material.dart';

class Rating {
  const Rating({
    @required this.restaurantId,
    @required this.userId,
    this.rating});

  final String userId;
  final String restaurantId;
  final double rating;

  factory Rating.fromJson(Map<String, dynamic> json) {

    return Rating(
      restaurantId: json['restaurantId'],
      rating: json['rating'],
      userId: json['userId']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'rating': rating,
      'userId': userId,
    };
  }
}
