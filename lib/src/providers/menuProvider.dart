import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreMenu.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/foodItem.dart';

class MenuProvider with ChangeNotifier {
  final firestoreService = FirestoreMenu();

  String _foodId;
  String _foodName;
  String _description;
  double _price;
  String _image;
  String _restaurantId;

  var uuid = Uuid();

  // Getters
  String get foodName => _foodName;
  String get description => _description;
  double get price => _price;
  String get image => _image;
  Stream<List<FoodItem>> get menu => firestoreService.getMenu(_restaurantId);

  // Setters
  set selectRestaurant(String restaurantId) {
    _restaurantId = restaurantId;
  }

  // Functions
  addFoodItem(String restaurantId, FoodItem foodItem) {
    if (foodItem.foodId != null) {
      _foodId = foodItem.foodId;
    } else {
      _foodId = uuid.v1();
    }

    _foodName = foodItem.foodName;
    _description = foodItem.description;
    _price = foodItem.price;
    _image = foodItem.image;
    _restaurantId = restaurantId;

    var newFoodItem = FoodItem(
        foodId: _foodId,
        foodName: _foodName,
        description: _description,
        price: _price,
        image: _image);
    firestoreService.setFoodItem(restaurantId, newFoodItem);
  }

  loadFoodItem(String restaurantId, FoodItem foodItem) {
    _foodName = foodItem.foodName;
    _description = foodItem.description;
    _price = foodItem.price;
    _image = foodItem.image;
    _restaurantId = restaurantId;
  }

  removeFoodItem(String restaurantId, String foodId) {
    firestoreService.removeFoodItem(restaurantId, foodId);
  }
}
