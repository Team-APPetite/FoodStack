import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/restaurant.dart';

GeoPoint location = GeoPoint(1.00, 100.0);

Restaurant mockRestaurant = Restaurant(
    restaurantId: "123",
    restaurantName: "Mc Donald's",
    cuisineType: "Fast Food",
    deliveryFee: 8.00,
    rating: 4.23,
    numOfRatings: 47,
    image: "",
    coordinates: location);

var jsonRestaurant = {
  "restaurantId": "123",
  "restaurantName": "Mc Donald's",
  "cuisineType": "Fast Food",
  "deliveryFee": 8.00,
  "rating": 4.23,
  "numOfRatings": 47,
  "image": "",
  "coordinates": location
};

var staticJsonRestaurant = {
  "restaurantId": "123",
  "restaurantName": "Mc Donald's",
  "cuisineType": "Fast Food",
  "deliveryFee": 8.00,
  "rating": 0,
  "image": "",
};
void main() async {
  group('Restaurant model', () {
    test('From json', () {
      Restaurant restaurant = Restaurant.fromJson(jsonRestaurant);
      expect(restaurant.restaurantId, mockRestaurant.restaurantId);
      expect(restaurant.restaurantName, mockRestaurant.restaurantName);
      expect(restaurant.cuisineType, mockRestaurant.cuisineType);
      expect(restaurant.deliveryFee, mockRestaurant.deliveryFee);
      expect(restaurant.rating, mockRestaurant.rating);
      expect(restaurant.numOfRatings, mockRestaurant.numOfRatings);
      expect(restaurant.image, mockRestaurant.image);
      expect(restaurant.coordinates, mockRestaurant.coordinates);
    });

    test('To map', () {
      expect(mockRestaurant.toMap(), jsonRestaurant);
    });

    test('Static to map', () {
      expect(mockRestaurant.staticToMap(), staticJsonRestaurant);
    }); 
  });
}
