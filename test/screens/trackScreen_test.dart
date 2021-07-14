import 'package:cloud_firestore/cloud_firestore.dart';
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

MockSharedPreferences prefs = MockSharedPreferences();

class MockOrderProvider extends Mock implements OrderProvider {
  setOrder(Order order, int joinDurationMins) async {
    prefs.setString('orderId', '123');
    prefs.setString('orderStatus', 'Status.active');
    prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 250);
  }

  setStatusAsPaid(String orderId) async {
    MockSharedPreferences prefs = MockSharedPreferences();
    prefs.setString('orderStatus', 'Status.paid');
  }

  setStatusAsPrepared(String orderId) async {
    MockSharedPreferences prefs = MockSharedPreferences();
    prefs.setString('orderStatus', 'Status.prepared');
  }

  setStatusAsDelivered(String orderId) async {
    MockSharedPreferences prefs = MockSharedPreferences();
    prefs.setString('orderStatus', 'Status.delivered');
  }

  setStatusAsNone(String orderId) async {
    MockSharedPreferences prefs = MockSharedPreferences();
    prefs.setString('orderStatus', 'Status.none');
  }
}

class MockSharedPreferences extends Mock implements SharedPreferences {
  String orderId;
  String orderStatus;
  int orderCompletionTime;

  int getInt(String key) {
    return orderCompletionTime;
  }

  String getString(String key) {
    return orderStatus;
  }

  setInt(String key, int value) {
    orderCompletionTime = value;
    return Stream.value(true).first;
  }

  setString(String key, String value) {
    orderStatus = value;
    return Stream.value(true).first;
  }
}

Order mockOrder = Order(
  orderId: "123",
);

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();
  // SharedPreferences.setMockInitialValues({'orderStatus': 'Status.none'});
  // await SharedPreferences.getInstance();
  var mockOrderProvider = MockOrderProvider();
  mockOrderProvider.setOrder(mockOrder, 0);

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

    test('demo', () {
      expect(1 + 1, 2);
    });

    // testWidgets('Track screen prompts user to place an order',
    //     (WidgetTester tester) async {
    //   // prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 125);
    //   await _buildTrackScreen(tester);
    //   mockOrderProvider.setStatusAsNone('123');
    //   // expect(find.byWidget(Scaffold()),
    //   //     findsOneWidget);
    //   expect(find.text("Place an order to track its status here!"),
    //       findsOneWidget);
    // });

    // testWidgets('Track screen says order is being prepared',
    //     (WidgetTester tester) async {
    //   await _buildTrackScreen(tester);
    //   // prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 25);
    //   expect(find.text("Your order is being prepared"), findsOneWidget);
    // });

    // testWidgets('Track screen says the order is being delivered',
    //     (WidgetTester tester) async {
    //   await _buildTrackScreen(tester);
    //   // prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 85);
    //   expect(find.text("Your order is being delivered"), findsOneWidget);
    // });

    // testWidgets('Track screen says the order is delivered',
    //     (WidgetTester tester) async {
    //   await _buildTrackScreen(tester);
    //   // prefs.setInt('orderCompletionTime', Timestamp.now().seconds - 115);
    //   expect(find.text("Enjoy your meal!"), findsOneWidget);
    // });
  });
}
