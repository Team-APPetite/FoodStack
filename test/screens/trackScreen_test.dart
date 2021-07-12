import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}



Order mockOrder = Order(
  orderId: "123",
);


void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  await SharedPreferences.getInstance();
  var orderProvider = OrderProvider();
  orderProvider.setOrder(mockOrder, 0);


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
          Provider(create: (context) => AuthBloc()),
        ],
        child: MaterialApp(
          title: 'FoodStack',
          home: TrackScreen(),

          // This mocked observer will now receive all navigation events
          // that happen in our app.
          navigatorObservers: [mockObserver],

        ),
      ));
    }


    testWidgets(
        'Track screen prompts user to place an order',
            (WidgetTester tester) async {
          await _buildTrackScreen(tester);
          orderProvider.setStatusAsNone(orderProvider.orderId);
          expect(find.text("Place an order to track its status here!"), findsOneWidget);
        });

    testWidgets(
        'Track screen says order is being prepared',
            (WidgetTester tester) async {
          await _buildTrackScreen(tester);
          orderProvider.setStatusAsPaid(orderProvider.orderId);
          expect(find.text("Your order is being prepared"), findsOneWidget);
        });

    testWidgets(
        'Track screen says the order is being delivered',
            (WidgetTester tester) async {
          await _buildTrackScreen(tester);
          orderProvider.setStatusAsPrepared(orderProvider.orderId);
          expect(find.text("Your order is being delivered"), findsOneWidget);
        });

    testWidgets(
        'Track screen says the order is delivered',
            (WidgetTester tester) async {
          await _buildTrackScreen(tester);
          orderProvider.setStatusAsDelivered(orderProvider.orderId);
          expect(find.text("Enjoy your meal!"), findsOneWidget);
        });

  });
}
