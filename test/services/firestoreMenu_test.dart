import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/services/firestoreMenu.dart';

List<FoodItem> mockFoodItems = [
  FoodItem(
      foodId: "123",
      foodName: "French Fries",
      description: "Salted potato fries",
      price: 4.50,
      image: ""),
  FoodItem(
      foodId: "456",
      foodName: "Ice Cream Cone",
      description: "Classic vanilla-flavoured ice cream",
      price: 1.95,
      image: ""),
  FoodItem(
      foodId: "789",
      foodName: "Chicken Wrap",
      description: "2 grilled chicken patties in a tortilla",
      price: 6.50,
      image: ""),
  FoodItem(
      foodId: "1011",
      foodName: "Chocolate Cake",
      description: "Chocolate cake baked to perfection",
      price: 5.65,
      image: ""),
];

void main() {
  final FirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
  final FirestoreMenu firestoreMenu =
      FirestoreMenu(firestore: fakeFirebaseFirestore);
  group('Firestore menu', () {
    test('Get menu', () async {
      await firestoreMenu.setFoodItem("123", mockFoodItems[0]);
      await firestoreMenu.setFoodItem("123", mockFoodItems[1]);
      await firestoreMenu.setFoodItem("123", mockFoodItems[2]);
      Stream<List<FoodItem>> menu = firestoreMenu.getMenu("123");
      menu.listen((event) {
        expect(event.length, 3);
        expect(event.elementAt(0).foodId, mockFoodItems[0].foodId);
        expect(event.elementAt(1).foodId, mockFoodItems[1].foodId);
        expect(event.elementAt(2).foodId, mockFoodItems[2].foodId);
      });
    });

    test('Add food item', () async {
      await firestoreMenu.setFoodItem("123", mockFoodItems[3]);
      Stream<List<FoodItem>> menu = firestoreMenu.getMenu("123");
      menu.listen((event) {
        expect(event.length, 4);
        expect(event.elementAt(0).foodId, mockFoodItems[0].foodId);
        expect(event.elementAt(1).foodId, mockFoodItems[1].foodId);
        expect(event.elementAt(2).foodId, mockFoodItems[2].foodId);
        expect(event.elementAt(3).foodId, mockFoodItems[3].foodId);
      });
    });

    test('Remove food item', () async {
      await firestoreMenu.removeFoodItem("123", mockFoodItems[1].foodId);
      Stream<List<FoodItem>> menu = firestoreMenu.getMenu("123");
      menu.listen((event) {
        expect(event.length, 3);
        expect(event.elementAt(0).foodId, mockFoodItems[0].foodId);
        expect(event.elementAt(1).foodId, mockFoodItems[2].foodId);
        expect(event.elementAt(2).foodId, mockFoodItems[3].foodId);
      });
    });
  });
}
