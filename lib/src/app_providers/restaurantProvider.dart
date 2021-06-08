import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreRestaurants.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  final firestoreService = FirestoreRestaurants();

  String _restaurantId;
  String _restaurantName;
  String _cuisineType;
  String _deliveryMins;
  double _rating;
  String _image;
  GeoPoint _coordinates;

  var uuid = Uuid();

  // Getters
  String get restaurantName => _restaurantName;
  String get cuisineType => _cuisineType;
  String get deliveryMins => _deliveryMins;
  double get rating => _rating;
  String get image => _image;
  GeoPoint get coordinates => _coordinates;
  Stream<List<Restaurant>> get restaurantsList =>
      firestoreService.getRestaurants();

  // Setters (Sample - Add more if needed)
  set changeRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
    notifyListeners();
  }

  // Functions
  addRestaurant(Restaurant restaurant) {
    if (restaurant.restaurantId != null) {
      _restaurantId = restaurant.restaurantId;
    } else {
      _restaurantId = uuid.v1();
    }

    _restaurantName = restaurant.restaurantName;
    _cuisineType = restaurant.cuisineType;
    _deliveryMins = restaurant.deliveryMins;
    _rating = restaurant.rating;
    _image = restaurant.image;
    _coordinates = restaurant.coordinates;

    var newRestaurant = Restaurant(
        restaurantId: _restaurantId,
        restaurantName: _restaurantName,
        cuisineType: _cuisineType,
        deliveryMins: _deliveryMins,
        rating: _rating,
        image: _image,
        coordinates: _coordinates);
    firestoreService.setRestaurant(newRestaurant);
  }

  removeRestaurant(String restaurantId) {
    firestoreService.removeRestaurant(restaurantId);
  }
}
