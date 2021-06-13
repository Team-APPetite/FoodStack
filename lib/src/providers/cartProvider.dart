import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/restaurant.dart';

class CartProvider with ChangeNotifier {

  int _joinDuration;
  int _itemCount;
  var _cartItems;

  var uuid = Uuid();

  int get joinDuration => _joinDuration;
  int get itemCount => _itemCount;
  int get cartItems => _cartItems;

  set joinDuration(int duration) {
    _joinDuration = duration;
    notifyListeners();
  }



  incrementItemCount({int increase = 1}) {
    _itemCount = _itemCount + increase;
    notifyListeners();
  }

  decrementItemCount({int decrease = 1}) {
    _itemCount = _itemCount - decrease;
    notifyListeners();
  }


  // // Functions
  // addRestaurant(Restaurant restaurant) {
  //   if (restaurant.restaurantId != null) {
  //     _restaurantId = restaurant.restaurantId;
  //   } else {
  //     _restaurantId = uuid.v1();
  //   }
  //
  //   _restaurantName = restaurant.restaurantName;
  //   _cuisineType = restaurant.cuisineType;
  //   _deliveryFee = restaurant.deliveryFee;
  //   _rating = restaurant.rating;
  //   _image = restaurant.image;
  //   _coordinates = restaurant.coordinates;
  //
  //   var newRestaurant = Restaurant(
  //       restaurantId: _restaurantId,
  //       restaurantName: _restaurantName,
  //       cuisineType: _cuisineType,
  //       deliveryFee: _deliveryFee,
  //       rating: _rating,
  //       image: _image,
  //       coordinates: _coordinates);
  //   firestoreService.setRestaurant(newRestaurant);
  // }
  //
  // removeRestaurant(String restaurantId) {
  //   firestoreService.removeRestaurant(restaurantId);
  // }

// void SaveNestedData() {
//   _db.collection("restaurants").add({
//     "name": "McD",
//     "cuisineType": "Fast Food",
//     "menu": [
//       {"food": "Meal", "price": 10.5},
//       {"food": "Burger", "price": 6.45},
//       {"food": "Pie", "price": 1.95}]
//   });
// }
}
