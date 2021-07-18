import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/paymentProvider.dart';
import 'package:foodstack/src/screens/orderSummary.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock.dart';
import '../navigation_test.dart';

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

Order mockOrder = Order(
  orderId: '123',
  cartIds: ["123", "345"],
  coordinates: GeoFirePoint(0.0, 0.0),
);

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  var cartProvider = CartProvider();
  var orderProvider = OrderProvider();

  group('Order Summary Screen', ()
  {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildOrderSummaryScreen(WidgetTester tester) async {
      await Firebase.initializeApp();

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => OrderProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(create: (context) => PaymentProvider()),
        ],
        child: MaterialApp(
          title: 'FoodStack',
          home: SummaryScreen(),
          navigatorObservers: [mockObserver],
        ),
      ));

      cartProvider.addToCart(mockCartItems[0]);
      cartProvider.addToCart(mockCartItems[1]);
      cartProvider.addToCart(mockCartItems[2]);
      cartProvider.addToCart(mockCartItems[3]);
      await cartProvider.confirmCart();


      orderProvider.setOrder(mockOrder, 0);

    }

    testWidgets('Subtotal displayed',
            (WidgetTester tester) async {
          await _buildOrderSummaryScreen(tester);
          await tester.pumpAndSettle();
          expect(find.text('Subtotal'), findsOneWidget);
          // expect(find.text('${cartProvider.subtotal}'),
          //     findsOneWidget);
        });

    testWidgets('Delivery fee displayed',
            (WidgetTester tester) async {
          await _buildOrderSummaryScreen(tester);
          await tester.pumpAndSettle();
          expect(find.text('Delivery Fee'), findsOneWidget);
          // expect(find.text('${cartProvider.subtotal}'),
          //     findsOneWidget);
        });

    testWidgets('Total displayed',
            (WidgetTester tester) async {
          await _buildOrderSummaryScreen(tester);
          await tester.pumpAndSettle();
          expect(find.text('Total'), findsOneWidget);
          // expect(find.text('${cartProvider.subtotal}'),
          //     findsOneWidget);
        });

  });
}