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
  double _deliveryFee;
  double _rating;
  String _image;
  GeoPoint _coordinates;

  Stream<List<String>> restaurantIdsList;
  var uuid = Uuid();

  // Getters
  String get restaurantId => _restaurantId;
  String get restaurantName => _restaurantName;
  String get cuisineType => _cuisineType;
  double get deliveryFee => _deliveryFee;
  double get rating => _rating;
  String get image => _image;
  GeoPoint get coordinates => _coordinates;
  Stream<List<Restaurant>> get restaurantsList =>
      firestoreService.getRestaurants();
  Stream<List<Restaurant>> get nearbyOrdersRestaurantsList =>
      getNearbyOrdersRestaurantsList();

  // Setters
  set changeRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
    notifyListeners();
  }

  // Functions
  Stream<List<Restaurant>> loadNearbyOrdersRestaurantsList(
      Stream<List<String>> restaurantIds) {
    List listOfRestaurantIds = [];
    restaurantIdsList = restaurantIds;
    restaurantIds.listen((listOfStrings) {
      if (listOfStrings.isNotEmpty) {
        int length = listOfStrings.length < 10 ? listOfStrings.length : 10;
        for (int i = 0; i < length; i++) {
          listOfRestaurantIds.add(1);
          listOfRestaurantIds[i] = listOfStrings[i];
        }
        firestoreService.loadNearbyOrderRestaurants(listOfRestaurantIds);
      }
    });
    return firestoreService.getNearbyOrderRestaurants();
  }

  Stream<List<Restaurant>> loadPastOrdersRestaurantsList(
      Stream<List<String>> restaurantIds) {
    List listOfRestaurantIds = [];
    restaurantIdsList = restaurantIds;
    restaurantIds.listen((listOfStrings) {
      if (listOfStrings.isNotEmpty) {
        int length = listOfStrings.length < 10 ? listOfStrings.length : 10;
        for (int i = 0; i < length; i++) {
          listOfRestaurantIds.add(1);
          listOfRestaurantIds[i] = listOfStrings[i];
        }
        firestoreService.loadPastOrders(listOfRestaurantIds);
      }
    });
    return firestoreService.getPastOrderRestaurants();
  }

  Stream<List<Restaurant>> getPastOrdersRestaurantsList() {
    return loadPastOrdersRestaurantsList(restaurantIdsList);
  }

  Stream<List<Restaurant>> getNearbyOrdersRestaurantsList() {
    return loadNearbyOrdersRestaurantsList(restaurantIdsList);
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
    _image = restaurant.image;
    _coordinates = restaurant.coordinates;

    var newRestaurant = Restaurant(
        restaurantId: _restaurantId,
        restaurantName: _restaurantName,
        cuisineType: _cuisineType,
        deliveryFee: _deliveryFee,
        rating: _rating,
        image: _image,
        coordinates: _coordinates);
    firestoreService.setRestaurant(newRestaurant);
  }

  removeRestaurant(String restaurantId) {
    firestoreService.removeRestaurant(restaurantId);
  }
}
