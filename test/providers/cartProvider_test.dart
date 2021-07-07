import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/utilities/numbers.dart';

import '../mock.dart';

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
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  var cartProvider = CartProvider();

  cartProvider.addToCart(mockCartItems[0]);
  cartProvider.addToCart(mockCartItems[1]);
  cartProvider.addToCart(mockCartItems[2]);
  cartProvider.addToCart(mockCartItems[3]);
  cartProvider.addToCart(mockCartItems[0]);
  cartProvider.addToCart(mockCartItems[1]);

  group('Cart Functionality', () {
    test('Add items to cart', () {
      expect(cartProvider.cartItems.length, 4);
    });

    test('Item quantity when singular', () {
      expect(cartProvider.getItemQuantityOf(mockCartItems[2].foodId), 1);
    });

    test('Item quantity when plural', () {
      expect(cartProvider.getItemQuantityOf(mockCartItems[0].foodId), 2);
    });

    test('Remove items from cart', () {
      cartProvider.removeFromCart(mockCartItems[0].foodId);
      expect(cartProvider.getItemQuantityOf(mockCartItems[0].foodId), 0);
    });

    test('Update item quantity', () {
      cartProvider.updateItemQuantityOf(mockCartItems[3].foodId, 4);
      expect(cartProvider.getItemQuantityOf(mockCartItems[3].foodId), 4);
    });

    test('Calculate subtotal', () {
      double subtotal = Numbers.roundTo2d((mockCartItems[0].price * 0) +
          (mockCartItems[1].price * 2) +
          mockCartItems[2].price +
          mockCartItems[3].price * 4);
      expect(cartProvider.getSubtotal(), subtotal);
    });

    test('Clear cart after confirm', () {
      cartProvider.clearCart();
      expect(cartProvider.cartItems.length, 0);
    });
  });
}
