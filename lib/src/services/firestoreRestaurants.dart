import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/models/user.dart';

class FirestoreRestaurants {
  FirebaseFirestore _db;
  FirebaseAuth _auth;

  FirestoreRestaurants({FirebaseFirestore firestore, FirebaseAuth fireauth}) {
    if (firestore != null && fireauth != null) {
      _db = firestore;
      _auth = fireauth;
    } else {
      _db = FirebaseFirestore.instance;
      _auth = FirebaseAuth.instance;
    }
  }

  Stream<List<Restaurant>> nearbyOrderRestaurants;

  // Create and Update
  Future<void> setRestaurant(Restaurant restaurant) {
    var options = SetOptions(merge: true);

    return _db
        .collection('restaurants')
        .doc(restaurant.restaurantId)
        .set(restaurant.toMap(), options);
  }

  // Read
  Future<Restaurant> getRestaurant(String restaurantId) {
    print("getRestaurant");
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .get()
        .then((snapshot) => Restaurant.fromJson(snapshot.data()));
  }

  // Delete
  Future<void> removeRestaurant(String restaurantId) {
    return _db.collection('restaurants').doc(restaurantId).delete();
  }

  Stream<List<Restaurant>> getRestaurants() {
    print("getRestaurants");
    return _db.collection('restaurants').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Restaurant.fromJson(doc.data())).toList());
  }

  Stream<List<Restaurant>> filterRestaurantsList(
      {List filters, String sortBy, bool isLowToHigh}) {
    print("filterRestaurantsList");
    if (filters.isEmpty && sortBy.isNotEmpty) {
      return _db
          .collection('restaurants')
          .orderBy(sortBy, descending: !isLowToHigh)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Restaurant.fromJson(doc.data()))
              .toList());
    } else if (sortBy.isEmpty && filters.isNotEmpty) {
      return _db
          .collection('restaurants')
          .where('cuisineType', whereIn: filters)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Restaurant.fromJson(doc.data()))
              .toList());
    } else if (sortBy.isNotEmpty && filters.isNotEmpty) {
      return _db
          .collection('restaurants')
          .where('cuisineType', whereIn: filters)
          .orderBy(sortBy, descending: !isLowToHigh)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Restaurant.fromJson(doc.data()))
              .toList());
    } else {
      return _db.collection('restaurants').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Restaurant.fromJson(doc.data())).toList());
    }
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
    Stream<List<Restaurant>> favouriteRestaurants;
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser.uid;

      favouriteRestaurants = _db
          .collection('users')
          .doc(uid)
          .get()
          .then((snapshot) => Users.fromFirestore(snapshot.data()))
          .then((value) =>
              value.favourites.map((e) => Restaurant.fromJson(e)).toList())
          .asStream();
    }

    return favouriteRestaurants ?? Stream.empty();
  }

  Future<void> addRating(String restaurantId, double newRating) async {
    await _db.runTransaction((transaction) async {
      DocumentReference restaurant =
          _db.collection('restaurants').doc(restaurantId);
      DocumentSnapshot snapshot = await transaction.get(restaurant);

      double averageRating = snapshot.get('rating');
      int numOfRatings = snapshot.get('numOfRatings');

      int newNumOfRatings = numOfRatings + 1;

      averageRating =
          ((averageRating * numOfRatings) + newRating) / newNumOfRatings;

      transaction.update(restaurant,
          {'rating': averageRating, 'numOfRatings': newNumOfRatings});
    });
  }
}
