import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/rating.dart';

class FirestoreRatings {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Set rating
  Future<void> addRating(Rating rating) {
    var options = SetOptions(merge: true);

    // Custom docId
    String ratingId = 'rating/${rating.userId}_${rating.restaurantId}';
    return _db.collection('rating').doc(ratingId).set(rating.toMap(), options);
  }

  // Get all ratings for specific restaurant
  Stream<List<Rating>> getRestaurantRating(String restaurantId) {
    return _db
        .collection('ratings')
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Rating.fromJson(doc.data())).toList());
  }

  // Get user rating for specific restaurant
  Stream<List<Rating>> getUserRatingForRestaurant(
      String restaurantId, String userId) {
    return _db
        .collection('ratings')
        .where('userId', isEqualTo: userId)
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Rating.fromJson(doc.data())).toList());
  }
}
