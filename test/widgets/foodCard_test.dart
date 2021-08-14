import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mock.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  setupFirebaseAuthMocks();

  group('Food card', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildFoodCard(WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => CartProvider()),
            ChangeNotifierProvider(create: (context) => MenuProvider()),
          ],
          child: MaterialApp(
            title: 'FoodStack',
            home: FoodCard(
                0, "123", "French Fries", "Salted potato fries", 2.95, '', "987"),
            navigatorObservers: [mockObserver],
          )));
    }

    Future<void> _increaseFoodItemQuantity(WidgetTester tester) async {
      final addButton = find.byKey(ValueKey('addToCart0'));
      await tester.tap(addButton);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Information displayed', (WidgetTester tester) async {
      await _buildFoodCard(tester);
      expect(find.text('French Fries'), findsOneWidget);
      expect(find.text('\$2.95'), findsOneWidget);
    });

    testWidgets('Add item once', (WidgetTester tester) async {
      await _buildFoodCard(tester);
      await _increaseFoodItemQuantity(tester);
      expect(find.text('x1'), findsOneWidget);
    });

    testWidgets('Add item multiple times', (WidgetTester tester) async {
      await _buildFoodCard(tester);
      for (int i = 0; i < 3; i++) {
        await _increaseFoodItemQuantity(tester);
      }
      expect(find.text('x3'), findsOneWidget);
    });
  });
}
