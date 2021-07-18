import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/paymentProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/screens/details.dart';
import 'package:foodstack/src/screens/favourites.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/screens/joinOrders.dart';
import 'package:foodstack/src/screens/newOrder.dart';
import 'package:foodstack/src/screens/orderSummary.dart';
import 'package:foodstack/src/screens/recentOrders.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  setupFirebaseAuthMocks();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  tearDown(() {});

  group('HomeScreen', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildHomeScreen(WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserLocator()),
            ChangeNotifierProvider(create: (context) => OrderProvider()),
            ChangeNotifierProvider(create: (context) => RestaurantProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
            Provider(create: (context) => AuthBloc()),
          ],
          child: MaterialApp(
            title: 'FoodStack',
            home: HomeScreen(),
            navigatorObservers: [mockObserver],
            routes: {
              '/newOrder': (context) => NewOrderScreen(),
              '/joinOrders': (context) => JoinOrdersScreen(),
              '/favourites': (context) => FavouritesScreen(),
              '/recentOrders': (context) => RecentOrdersScreen(),
            },
          )));
    }

    Future<void> _navigateToNewOrderScreen(WidgetTester tester) async {
      var newOrder = find.descendant(
          of: find.byType(Row), matching: find.text('Start a\nNew Order'));

      await tester.tap(newOrder);
      await tester.pump();
      await tester.pump();
    }

    Future<void> _navigateToJoinOrderScreen(WidgetTester tester) async {
      var joinOrder = find.descendant(
          of: find.byType(Row), matching: find.text('Join\nOrders'));
      await tester.tap(joinOrder);
      await tester.pump();
      await tester.pump();
    }

    Future<void> _navigateToFavouriteScreen(WidgetTester tester) async {
      var favourite = find.descendant(
          of: find.byType(Row), matching: find.text('Your\nFavourites'));
      await tester.tap(favourite);
      await tester.pump();
      await tester.pump();
    }

    Future<void> _navigateToRecentOrderScreen(WidgetTester tester) async {
      var recentOrder = find.descendant(
          of: find.byType(Row), matching: find.text('Order\nAgain'));
      await tester.tap(recentOrder);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Navigate to New Order Screen', (WidgetTester tester) async {
      await _buildHomeScreen(tester);
      await prefs.setBool('isPooler', false);
      await _navigateToNewOrderScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(NewOrderScreen), findsOneWidget);
    });

    testWidgets('Navigate to Join Order Screen', (WidgetTester tester) async {
      await _buildHomeScreen(tester);
      await prefs.setBool('isPooler', true);
      await _navigateToJoinOrderScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(JoinOrdersScreen), findsOneWidget);
    });

    testWidgets('Navigate to Favourites Screen', (WidgetTester tester) async {
      await _buildHomeScreen(tester);
      await _navigateToFavouriteScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(FavouritesScreen), findsOneWidget);
    });

    testWidgets('Navigate to Recent Order Screen', (WidgetTester tester) async {
      await _buildHomeScreen(tester);
      await _navigateToRecentOrderScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(RecentOrdersScreen), findsOneWidget);
    });
  });

  group('Checkout', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildCheckoutScreen(WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserLocator()),
            ChangeNotifierProvider(create: (context) => OrderProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
            ChangeNotifierProvider(create: (context) => PaymentProvider()),
          ],
          child: MaterialApp(
            title: 'FoodStack',
            home: CheckoutScreen(null),
            navigatorObservers: [mockObserver],
            routes: {
              '/orderSummary': (context) => SummaryScreen(),
            },
          )));
    }

    Future<void> _navigateToOrderSummaryScreen(WidgetTester tester) async {
      final cashOnDeliveryOption = find.byKey(ValueKey('paymentOption1'));
      final payButton = find.byKey(ValueKey('payButton'));
      await tester.tap(cashOnDeliveryOption);
      await tester.tap(payButton);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Navigate to Order Summary Screen',
        (WidgetTester tester) async {
      await _buildCheckoutScreen(tester);
      await _navigateToOrderSummaryScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SummaryScreen), findsOneWidget);
    });
  });

  group('Back button', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildHomeScreen(WidgetTester tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserLocator()),
            ChangeNotifierProvider(create: (context) => OrderProvider()),
            ChangeNotifierProvider(create: (context) => RestaurantProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
            Provider(create: (context) => AuthBloc()),
          ],
          child: MaterialApp(
            title: 'FoodStack',
            home: HomeScreen(),
            navigatorObservers: [mockObserver],
            routes: {
              '/newOrder': (context) => NewOrderScreen(),
              '/joinOrders': (context) => JoinOrdersScreen(),
              '/favourites': (context) => FavouritesScreen(),
              '/recentOrders': (context) => RecentOrdersScreen(),
            },
          )));
    }

    Future<void> _navigateToNewOrderScreen(WidgetTester tester) async {
      var newOrder = find.descendant(
          of: find.byType(Row), matching: find.text('Start a\nNew Order'));
      await tester.tap(newOrder);
      await tester.pump();
      await tester.pump();
    }

    Future<void> _navigateToPreviousScreen(WidgetTester tester) async {
      final backButton = find.byKey(ValueKey('backButton'));
      await tester.tap(backButton);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Navigate to Previous Screen', (WidgetTester tester) async {
      await _buildHomeScreen(tester);
      await prefs.setBool('isPooler', false);
      await _navigateToNewOrderScreen(tester);

      verify(mockObserver.didPush(any, any));
      expect(find.byType(NewOrderScreen), findsOneWidget);

      await _navigateToPreviousScreen(tester);

      verify(mockObserver.didPop(any, any));
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

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
            home: FoodCard("123", "French Fries", "Salted potato fries", 2.95, '', "987"),
            navigatorObservers: [mockObserver],
            routes: {
              '/details': (context) => DetailsScreen(),
            },
          )));
    }

    Future<void> _navigateToDetailsScreen(WidgetTester tester) async {
      final foodCard = find.byKey(ValueKey('foodCard_French Fries'));
      await tester.tap(foodCard);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Navigate to Details Screen',
        (WidgetTester tester) async {
      await _buildFoodCard(tester);
      await _navigateToDetailsScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(DetailsScreen), findsOneWidget);
    });
  });
}