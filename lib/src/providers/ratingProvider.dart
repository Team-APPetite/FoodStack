import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreRatings.dart';
import 'package:foodstack/src/models/rating.dart';

class RatingProvider with ChangeNotifier {
  final firestoreService = FirestoreRatings();

  String _restaurantId;
  String _userId;
  double _rating;



  // Getters
  double get rating => _rating;

  // Setters


  // Functions
  Stream<List<Rating>> loadRestaurantRatings(
      String restaurantId) {
    return firestoreService.getRestaurantRating(restaurantId);
  }


  addRating(Rating rating) {
    _restaurantId = rating.restaurantId;
    _userId = rating.userId;
    _rating = rating.rating;

    var newRating = Rating(
        restaurantId: _restaurantId,
        rating: _rating,
        userId: _userId);
    firestoreService.addRating(newRating);
  }

}
