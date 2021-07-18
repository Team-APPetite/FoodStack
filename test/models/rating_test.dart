import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/rating.dart';

Rating mockRating = Rating(restaurantId: "123", userId: "456", rating: 3.5);

var jsonRating = {"restaurantId": "123", "userId": "456", "rating": 3.5};

void main() async {
  group('Rating model', () {
    test('From json', () {
      Rating rating = Rating.fromJson(jsonRating);
      expect(rating.restaurantId, mockRating.restaurantId);
      expect(rating.userId, mockRating.userId);
      expect(rating.rating, mockRating.rating);
    });

    test('To map', () {
      expect(mockRating.toMap(), jsonRating);
    });
  });
}
