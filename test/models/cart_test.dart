import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/cart.dart';

Cart mockCart =
    Cart("123", "456", "789", "Mc Donalds", 7.65, 8.00, mockCartItems);

List<CartItem> mockCartItems = [
  CartItem(
      foodId: "123",
      foodName: "French Fries",
      price: 4.50,
      quantity: 1,
      notes: "none"),
  CartItem(
      foodId: "456",
      foodName: "Ice Cream Cone",
      price: 1.95,
      quantity: 1,
      notes: "none"),
  CartItem(
      foodId: "789",
      foodName: "Chicken Wrap",
      price: 6.50,
      quantity: 1,
      notes: "none"),
  CartItem(
      foodId: "1011",
      foodName: "Chocolate Cake",
      price: 5.65,
      quantity: 1,
      notes: "none"),
];

void main() async {
  group('Cart model', () {
    test('From json', () {
      var cartItem1 = {
        "foodId": "123",
        "foodName": "French Fries",
        "price": 4.50,
        "quantity": 1,
        "notes": "none"
      };

      var cartItem2 = {
        "foodId": "456",
        "foodName": "Ice Cream Cone",
        "price": 1.95,
        "quantity": 1,
        "notes": "none"
      };

      var cartItem3 = {
        "foodId": "789",
        "foodName": "Chicken Wrap",
        "price": 6.50,
        "quantity": 1,
        "notes": "none"
      };

      var cartItem4 = {
        "foodId": "1011",
        "foodName": "Chocolate Cake",
        "price": 5.65,
        "quantity": 1,
        "notes": "none"
      };

      List cartItems = [cartItem1, cartItem2, cartItem3, cartItem4];

      Cart cart = Cart.fromJson({
        "cartId": "123",
        "userId": "456",
        "restaurantId": "789",
        "restaurantName": "Mc Donalds",
        "subtotal": 7.65,
        "deliveryFee": 8.00,
        "cartItems":
            cartItems.map((cartItem) => CartItem.fromJson(cartItem)).toList()
      });
      expect(cart.cartId, mockCart.cartId);
      expect(cart.userId, mockCart.userId);
      expect(cart.restaurantId, mockCart.restaurantId);
      expect(cart.restaurantName, mockCart.restaurantName);
      expect(cart.subtotal, mockCart.subtotal);
      expect(cart.deliveryFee, mockCart.deliveryFee);
    });

    test('To map', () {
      var cartItem1 = {
        "foodId": "123",
        "foodName": "French Fries",
        "image": null,
        "price": 4.50,
        "quantity": 1,
        "notes": "none"
      };

      var cartItem2 = {
        "foodId": "456",
        "foodName": "Ice Cream Cone",
        "image": null,
        "price": 1.95,
        "quantity": 1,
        "notes": "none"
      };

      var cartItem3 = {
        "foodId": "789",
        "foodName": "Chicken Wrap",
        "image": null,
        "price": 6.50,
        "quantity": 1,
        "notes": "none"
      };

      var cartItem4 = {
        "foodId": "1011",
        "foodName": "Chocolate Cake",
        "image": null,
        "price": 5.65,
        "quantity": 1,
        "notes": "none"
      };

      List cartItems = [cartItem1, cartItem2, cartItem3, cartItem4];

      var cart = {
        "cartId": "123",
        "userId": "456",
        "restaurantId": "789",
        "restaurantName": "Mc Donalds",
        "subtotal": 7.65,
        "deliveryFee": 8.00,
        "cartItems": cartItems
      };

      mockCart.cartItems = mockCart.cartItems.map((e) => e.toMap()).toList();

      expect(mockCart.toMap(), cart);
    });
  });
}
