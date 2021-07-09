import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/models/user.dart';

class FirestoreRestaurants {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<Restaurant>> nearbyOrderRestaurants;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
    return nearbyOrders.isNotEmpty
        ? _db
            .collection('restaurants')
            .where('restaurantId', whereIn: nearbyOrders)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Restaurant.fromJson(doc.data()))
                .toList())
        : null;
  }

  Stream<List<Restaurant>> getFavouriteRestaurants() {
    print("getFavouriteRestaurants");
    String uid = _auth.currentUser.uid;
    return _db
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) => Users.fromFirestore(snapshot.data()))
        .then((value) =>
            value.favourites.map((e) => Restaurant.fromJson(e)).toList())
        .asStream();
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
