import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/foodItem.dart';

class FirestoreMenu {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Stream<List<FoodItem>> getMenu(String restaurantId) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FoodItem.fromJson(doc.data())).toList());
  }

  // Read and Update
  Future<void> setFoodItem(String restaurantId, FoodItem foodItem) {
    var options = SetOptions(merge: true);

    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(foodItem.foodId)
        .set(foodItem.toMap(), options);
  }

  // Delete
  Future<void> removeFoodItem(String restaurantId, String foodId) {
    return _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(foodId)
        .delete();
  }
}
