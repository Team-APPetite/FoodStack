import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/foodItem.dart';

FoodItem mockFoodItem = FoodItem(
    foodId: "123",
    foodName: "French Fries",
    description: "Salted potato fries",
    price: 3.65,
    image: "");

var jsonFoodItem = {
  "foodId": "123",
  "foodName": "French Fries",
  "description": "Salted potato fries",
  "price": 3.65,
  "image": ""
};

void main() async {
  group('Food item model', () {
    test('From json', () {
      FoodItem foodItem = FoodItem.fromJson(jsonFoodItem);
      expect(foodItem.foodId, mockFoodItem.foodId);
      expect(foodItem.foodName, mockFoodItem.foodName);
      expect(foodItem.description, mockFoodItem.description);
      expect(foodItem.price, mockFoodItem.price);
      expect(foodItem.image, mockFoodItem.image);
    });

    test('To map', () {
      expect(mockFoodItem.toMap(), jsonFoodItem);
    });
  });
}
