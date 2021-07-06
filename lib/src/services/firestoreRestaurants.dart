import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/models/restaurant.dart';

class FirestoreRestaurants {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<Restaurant>> nearbyOrderRestaurants;

  // Read
  Future<Restaurant> getRestaurant(String restaurantId) {
    print("getRestaurant");
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .get()
        .then((snapshot) => Restaurant.fromJson(snapshot.data()));
  }

  Stream<List<Restaurant>> getRestaurants() {
    print("getRestaurants");
    return _db.collection('restaurants').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Restaurant.fromJson(doc.data())).toList());
  }

  Stream<List<Restaurant>> loadNearbyOrderRestaurants(List nearbyOrders) {
    return nearbyOrders.isNotEmpty ?
    _db
        .collection('restaurants')
        .where('restaurantId', whereIn: nearbyOrders)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Restaurant.fromJson(doc.data()))
            .toList()) : null;
  }

  // Create and Update
  Future<void> setRestaurant(Restaurant restaurant) {
    var options = SetOptions(merge: true);

    return _db
        .collection('restaurants')
        .doc(restaurant.restaurantId)
        .set(restaurant.toMap(), options);
  }

  // Delete
  Future<void> removeRestaurant(String restaurantId) {
    return _db.collection('restaurants').doc(restaurantId).delete();
  }
}
