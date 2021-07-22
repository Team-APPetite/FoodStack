import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/services/firestoreCarts.dart';

Timestamp currentTime = Timestamp.now();

Cart mockCart1 =
    Cart("123", "456", "789", "Mc Donalds", 7.65, 8.00, mockCartItems, currentTime);
Cart mockCart2 = Cart("abc", "def", "gtg", "KFC", 10.95, 4.00, mockCartItems, currentTime);
Cart mockCart3 =
    Cart("xyz", "vfh", "bgn", "Pizza Hut", 22.80, 10.00, mockCartItems, currentTime);

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

void main() {
  final FirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
  final FirestoreCarts firestoreCarts =
      FirestoreCarts(firestore: fakeFirebaseFirestore);
  group('Firestore cart', () {
    test('Add cart', () async {
      mockCart1.cartItems = mockCart1.cartItems.map((e) => e.toMap()).toList();
      mockCart2.cartItems = mockCart2.cartItems.map((e) => e.toMap()).toList();
      mockCart3.cartItems = mockCart3.cartItems.map((e) => e.toMap()).toList();
      await firestoreCarts.setCart(mockCart1);
      await firestoreCarts.setCart(mockCart2);
      await firestoreCarts.setCart(mockCart3);
      Cart cart = await firestoreCarts.getCart(mockCart1.cartId);
      expect(cart.cartId, mockCart1.cartId);
      expect(cart.userId, mockCart1.userId);
      expect(cart.restaurantId, mockCart1.restaurantId);
      expect(cart.restaurantName, mockCart1.restaurantName);
      expect(cart.subtotal, mockCart1.subtotal);
      expect(cart.deliveryFee, mockCart1.deliveryFee);
    });

    test('Get cart', () async {
      Cart cart = await firestoreCarts.getCart(mockCart3.cartId);
      expect(cart.cartId, mockCart3.cartId);
      expect(cart.userId, mockCart3.userId);
      expect(cart.restaurantId, mockCart3.restaurantId);
      expect(cart.restaurantName, mockCart3.restaurantName);
      expect(cart.subtotal, mockCart3.subtotal);
      expect(cart.deliveryFee, mockCart3.deliveryFee);
    });

    test('Delete cart', () async {
      await firestoreCarts.deleteCart(mockCart2.cartId);
      Cart cart = await firestoreCarts.getCart(mockCart2.cartId);
      expect(cart, null);
    });

    test('Get recent carts', () async {
      Stream<List<Cart>> recentCarts = firestoreCarts.getRecentCarts("vfh");
      recentCarts.listen((event) {
        expect(event.first.cartId, mockCart3.cartId);
      });
    });
  });
}
