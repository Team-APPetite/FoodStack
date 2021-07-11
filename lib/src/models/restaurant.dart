import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Restaurant {
  final String restaurantId;
  final String restaurantName;
  final String cuisineType;
  final double deliveryFee;
  final double rating;
  final int numOfRatings;
  final String image;
  final GeoPoint coordinates;

  Restaurant(
      {@required this.restaurantId,
      this.restaurantName,
      this.cuisineType,
      this.deliveryFee,
      this.rating,
      this.numOfRatings,
      this.image,
      this.coordinates});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        restaurantId: json['restaurantId'],
        restaurantName: json['restaurantName'],
        cuisineType: json['cuisineType'],
        deliveryFee: json['deliveryFee'].toDouble(),
        rating: json['rating'].toDouble(),
        numOfRatings: json['numOfRatings'],
        image: json['image'],
        coordinates: json['coordinates']);
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'cuisineType': cuisineType,
      'deliveryFee': deliveryFee,
      'rating': rating,
      'numOfRatings': numOfRatings,
      'image': image,
      'coordinates': coordinates
    };
  }

  Map<String, dynamic> staticToMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'cuisineType': cuisineType,
      'deliveryFee': deliveryFee,
      'rating': 0,
      'image': image,
    };
  }
}
