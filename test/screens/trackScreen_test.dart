import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  group('Track Screen', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildTrackScreen(WidgetTester tester) async {
      await Firebase.initializeApp();

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => OrderProvider()),
        ],
        child: MaterialApp(
          title: 'FoodStack',
          home: TrackScreen(),
          navigatorObservers: [mockObserver],
        ),
      ));
    }

    testWidgets('Track screen prompts user to place an order',
        (WidgetTester tester) async {
           prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 125);
      await _buildTrackScreen(tester);
      await prefs.setString('orderStatus', 'Status.none');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text("\nPlace an order to track its status here!\n"),
          findsOneWidget);
    });

    testWidgets('Track screen says order is being prepared',
        (WidgetTester tester) async {
           prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 2);
      await _buildTrackScreen(tester);
      await prefs.setString('orderStatus', 'Status.paid');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text("Your order is being prepared"), findsOneWidget);
    });

    testWidgets('Track screen says the order is being delivered',
        (WidgetTester tester) async {
           prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 65);
      await _buildTrackScreen(tester);
      await prefs.setString('orderStatus', 'Status.prepared');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text("Your order is being delivered"), findsOneWidget);
    });

    testWidgets('Track screen says the order is delivered',
        (WidgetTester tester) async {
           prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 95);
      await _buildTrackScreen(tester);
      await prefs.setString('orderStatus', 'Status.delivered');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text("Enjoy your meal!"), findsOneWidget);
    });
  });
}
