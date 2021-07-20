import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/services/firestoreRestaurants.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

GeoPoint location1 = GeoPoint(1.00, 101.0);
GeoPoint location2 = GeoPoint(2.00, 102.0);
GeoPoint location3 = GeoPoint(3.00, 103.0);
GeoPoint location4 = GeoPoint(4.00, 104.0);

List<Restaurant> mockRestaurants = [
  Restaurant(
      restaurantId: "123",
      restaurantName: "Mc Donald's",
      cuisineType: "Fast Food",
      deliveryFee: 8.00,
      rating: 3.8,
      numOfRatings: 28,
      image: "",
      coordinates: location1),
  Restaurant(
      restaurantId: "456",
      restaurantName: "Burger Boy",
      cuisineType: "Fast Food",
      deliveryFee: 6.90,
      rating: 3.43,
      numOfRatings: 47,
      image: "",
      coordinates: location2),
  Restaurant(
      restaurantId: "789",
      restaurantName: "Playmade",
      cuisineType: "Beverages",
      deliveryFee: 12.25,
      rating: 4.27,
      numOfRatings: 91,
      image: "",
      coordinates: location3),
  Restaurant(
      restaurantId: "1011",
      restaurantName: "Al Amaan Restaurant",
      cuisineType: "Casual",
      deliveryFee: 4.50,
      rating: 3.8,
      numOfRatings: 29,
      image: "",
      coordinates: location4),
];

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

  final FirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
  final FirestoreRestaurants firestoreRestaurants = FirestoreRestaurants(
      firestore: fakeFirebaseFirestore, fireauth: mockFirebaseAuth);
  group('Firestore restaurants', () {
    test('Add restaurant', () async {
      await firestoreRestaurants.setRestaurant(mockRestaurants[0]);
      await firestoreRestaurants.setRestaurant(mockRestaurants[1]);
      await firestoreRestaurants.setRestaurant(mockRestaurants[2]);
      await firestoreRestaurants.setRestaurant(mockRestaurants[3]);
    });

    test('Get restaurant', () async {
      Restaurant restaurant = await firestoreRestaurants
          .getRestaurant(mockRestaurants[1].restaurantId);
      expect(restaurant.restaurantId, mockRestaurants[1].restaurantId);
      expect(restaurant.restaurantName, mockRestaurants[1].restaurantName);
      expect(restaurant.cuisineType, mockRestaurants[1].cuisineType);
      expect(restaurant.deliveryFee, mockRestaurants[1].deliveryFee);
      expect(restaurant.rating, mockRestaurants[1].rating);
      expect(restaurant.numOfRatings, mockRestaurants[1].numOfRatings);
      expect(restaurant.image, mockRestaurants[1].image);
      expect(restaurant.coordinates, mockRestaurants[1].coordinates);
    });

    test('Delete restaurant', () async {
      await firestoreRestaurants
          .removeRestaurant(mockRestaurants[2].restaurantId);
      Stream<List<Restaurant>> restaurantsList =
          firestoreRestaurants.getRestaurants();
      restaurantsList.listen((event) {
        expect(event.length, 3);
      });
    });

    test('Get restaurants list', () async {
      Stream<List<Restaurant>> restaurantsList =
          firestoreRestaurants.getRestaurants();
      restaurantsList.listen((event) {
        expect(event.length, 3);
        expect(
            event.elementAt(0).restaurantId, mockRestaurants[0].restaurantId);
        expect(
            event.elementAt(1).restaurantId, mockRestaurants[1].restaurantId);
        expect(
            event.elementAt(2).restaurantId, mockRestaurants[3].restaurantId);
      });
    });

    test('Filter restaurants list', () async {
      //  await firestoreRestaurants.setRestaurant(mockRestaurants[1]);
      Stream<List<Restaurant>> filteredList = firestoreRestaurants
          .filterRestaurantsList(
              filters: ["Casual"], sortBy: "", isLowToHigh: true);
      filteredList.listen((event) {
        expect(event.length, 1);
        expect(
            event.elementAt(0).restaurantId, mockRestaurants[3].restaurantId);
      });

      Stream<List<Restaurant>> sortedList = firestoreRestaurants
          .filterRestaurantsList(
              filters: [], sortBy: "deliveryFee", isLowToHigh: false);
      sortedList.listen((event) {
        expect(event.length, 3);
        expect(
            event.elementAt(0).restaurantId, mockRestaurants[0].restaurantId);
        expect(
            event.elementAt(1).restaurantId, mockRestaurants[1].restaurantId);
        expect(
            event.elementAt(2).restaurantId, mockRestaurants[3].restaurantId);
      });

      Stream<List<Restaurant>> filteredAndSortedList = firestoreRestaurants
          .filterRestaurantsList(
              filters: ["Fast Food"], sortBy: "rating", isLowToHigh: true);

      filteredAndSortedList.listen((event) {
        expect(event.length, 2);
        expect(
            event.elementAt(0).restaurantId, mockRestaurants[1].restaurantId);
        expect(
            event.elementAt(1).restaurantId, mockRestaurants[0].restaurantId);
      });


      Stream<List<Restaurant>> noFiltersList = firestoreRestaurants
          .filterRestaurantsList(
              filters: [], sortBy: "", isLowToHigh: true);

      noFiltersList.listen((event) {
        expect(event.length, 3);
        expect(
            event.elementAt(0).restaurantId, mockRestaurants[0].restaurantId);
        expect(
            event.elementAt(1).restaurantId, mockRestaurants[1].restaurantId);
            expect(
            event.elementAt(2).restaurantId, mockRestaurants[3].restaurantId);
      });
    });

    test('Load nearby order restaurants list', () async {
      Stream<List<Restaurant>> nearbyOrderRestaurants =
          firestoreRestaurants.loadNearbyOrderRestaurants(["123", "1011"]);
      nearbyOrderRestaurants.listen((event) {
        expect(event.length, 2);
        expect(
            event.elementAt(0).restaurantId, mockRestaurants[0].restaurantId);
        expect(
            event.elementAt(1).restaurantId, mockRestaurants[3].restaurantId);
      });
    });

    test('Get favourite restaurants list', () async {
      // No restaurants in list
      Stream<List<Restaurant>> favouriteRestaurants =
          firestoreRestaurants.getFavouriteRestaurants();
      favouriteRestaurants.listen((event) {
        expect(event.length, 0);
      });
    });

    test('Add rating for a restaurant', () async {
      await firestoreRestaurants.addRating("123", 5);
      Restaurant restaurant = await firestoreRestaurants.getRestaurant("123");
      double rating = restaurant.rating;
      int numOfRatings = restaurant.numOfRatings;

      expect(rating, ((3.8 * 28) + 5) / 29);
      expect(numOfRatings, 29);
    });
  });
}
