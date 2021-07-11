import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreRestaurants.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  final firestoreService = FirestoreRestaurants();
  bool flag = false;

  String _restaurantId;
  String _restaurantName;
  String _cuisineType;
  double _deliveryFee;
  double _rating;
  int _numOfRatings;
  String _image;
  GeoPoint _coordinates;

  var uuid = Uuid();

  // Getters
  String get restaurantId => _restaurantId;
  String get restaurantName => _restaurantName;
  String get cuisineType => _cuisineType;
  double get deliveryFee => _deliveryFee;
  double get rating => _rating;
  int get numOfRatings => _numOfRatings;
  String get image => _image;
  GeoPoint get coordinates => _coordinates;
  Stream<List<Restaurant>> get restaurantsList =>
      firestoreService.getRestaurants();

  // Setters
  set changeRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
    notifyListeners();
  }

  // Functions
  Stream<List<Restaurant>> loadNearbyOrdersRestaurantsList(
      List<String> restaurantIds) {
    return firestoreService
        .loadNearbyOrderRestaurants(restaurantIds.take(10).toList());
  }

  Stream<List<Restaurant>> getFavouriteRestaurants() {
    return firestoreService.getFavouriteRestaurants();
  }

  setFlag() {
    flag = true;
  }

  getFlag() {
    return flag;
  }

  Future<void> checkNearbyOrderFromRestaurant(
      Stream<List<String>> restaurantIds, String currRestaurantId) async {
    restaurantIds.listen((listOfStrings) {
      for (int i = 0; i < listOfStrings.length; i++) {
        if (currRestaurantId == listOfStrings[i]) {
          setFlag();
          return;
        }
      }
      flag = false;
    });
  }

  addRestaurant(Restaurant restaurant) {
    if (restaurant.restaurantId != null) {
      _restaurantId = restaurant.restaurantId;
    } else {
      _restaurantId = uuid.v1();
    }

    _restaurantName = restaurant.restaurantName;
    _cuisineType = restaurant.cuisineType;
    _deliveryFee = restaurant.deliveryFee;
    _rating = restaurant.rating;
    _numOfRatings = restaurant.numOfRatings;
    _image = restaurant.image;
    _coordinates = restaurant.coordinates;

    var newRestaurant = Restaurant(
        restaurantId: _restaurantId,
        restaurantName: _restaurantName,
        cuisineType: _cuisineType,
        deliveryFee: _deliveryFee,
        rating: _rating,
        numOfRatings: _numOfRatings,
        image: _image,
        coordinates: _coordinates);
    firestoreService.setRestaurant(newRestaurant);
  }

  getRestaurant(String restaurantId) async {
    Restaurant restaurant = await firestoreService.getRestaurant(restaurantId);
    _restaurantId = restaurant.restaurantId;
    _restaurantName = restaurant.restaurantName;
    _cuisineType = restaurant.cuisineType;
    _deliveryFee = restaurant.deliveryFee;
    _rating = restaurant.rating;
    _numOfRatings = restaurant.numOfRatings;
    _image = restaurant.image;
    _coordinates = restaurant.coordinates;
  }

  removeRestaurant(String restaurantId) {
    firestoreService.removeRestaurant(restaurantId);
  }

  addRating(String restaurantId, double newRating) {
    firestoreService.addRating(_restaurantId, newRating);
  }
}
