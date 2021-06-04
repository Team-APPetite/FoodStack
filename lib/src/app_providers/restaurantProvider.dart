import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreService.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _restaurantId;
  String _restaurantName;
  String _cuisineType;
  String _deliveryMins;
  double _rating;
  String _image;

  var uuid = Uuid();

  // Getters
  String get restaurantName => _restaurantName;
  String get cuisineType => _cuisineType;
  String get deliveryMins => _deliveryMins;
  double get rating => _rating;
  String get image => _image;
  Stream<List<Restaurant>> get restaurantsList => firestoreService.getRestaurants();

  // Setters (Sample - Add more if needed)
  set changeRestaurantName(String restaurantName) {
    _restaurantName = restaurantName;
    notifyListeners();
  }

  // Functions
  loadRestaurant(Restaurant restaurant){
    if (restaurant != null){
      _restaurantId = restaurant.restaurantId;
      _restaurantName = restaurant.restaurantName;
      _cuisineType = restaurant.cuisineType;
      _deliveryMins = restaurant.deliveryMins;
      _rating = restaurant.rating;
      _image = restaurant.image;
    } else {
      _restaurantId = null;
      _restaurantName = null;
      _cuisineType = null;
      _deliveryMins = null;
      _rating = null;;
      _image = null;
    }
  }

  addRestaurant(){
    if (_restaurantId == null){
      //Add
      var newRestaurant = Restaurant(restaurantId: uuid.v1(), restaurantName: _restaurantName, cuisineType: _cuisineType, deliveryMins: _deliveryMins, rating: _rating, image: _image);
      firestoreService.setRestaurant(newRestaurant);
    } else {
      //Edit
      var updatedRestaurant = Restaurant(restaurantId: _restaurantId, restaurantName: _restaurantName, cuisineType: _cuisineType, deliveryMins: _deliveryMins, rating: _rating, image: _image);
      firestoreService.setRestaurant(updatedRestaurant);
    }
  }

  removeRestaurant(String restaurantId){
    firestoreService.removeRestaurant(restaurantId);
  }

}