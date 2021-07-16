import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/screens/authentication/login.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/screens/profile.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mock.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  setupFirebaseAuthMocks();

  group('Bottom Navigation Bar - Navigation tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildNavBar(WidgetTester tester) async {
      await Firebase.initializeApp();

      await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserLocator()),
            ChangeNotifierProvider(create: (context) => OrderProvider()),
            ChangeNotifierProvider(create: (context) => RestaurantProvider()),
            Provider(create: (context) => AuthBloc()),
          ],
          child: MaterialApp(
            title: 'FoodStack',
            home: CustomBottomNavBar(
              selectedMenu: null,
            ),
            // This mocked observer will now receive all navigation events
            // that happen in our app.
            navigatorObservers: [mockObserver],
            routes: {
              '/home': (context) => HomeScreen(),
              '/profile': (context) => ProfileScreen(),
              '/trackOrder': (context) => TrackScreen(),
              '/login': (context) => LoginScreen(),
            },
          )));
    }

    Future<void> _navigateToHomeScreen(WidgetTester tester) async {
      var home = find.descendant(
          of: find.byType(Row),
          matching: find.byKey(CustomBottomNavBar.navigateToHomeScreenKey));
      await tester.tap(home);
      await tester.pumpAndSettle();
    }

    Future<void> _navigateToTrackScreen(WidgetTester tester) async {
      var track = find.descendant(
          of: find.byType(Row),
          matching: find.byKey(CustomBottomNavBar.navigateToTrackScreenKey));
      await tester.tap(track);
      await tester.pumpAndSettle();
    }

    Future<void> _navigateToProfileScreen(WidgetTester tester) async {
      var profile = find.descendant(
          of: find.byType(Row),
          matching: find.byKey(CustomBottomNavBar.navigateToProfileScreenKey));
      await tester.tap(profile);
      await tester.pumpAndSettle();
    }

    testWidgets('Navigate to Home Screen', (WidgetTester tester) async {
      await _buildNavBar(tester);
      await _navigateToHomeScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Navigate to Track Screen', (WidgetTester tester) async {
      await _buildNavBar(tester);
      await _navigateToTrackScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(TrackScreen), findsOneWidget);
    });
    testWidgets('Navigate to Profile Screen', (WidgetTester tester) async {
      await _buildNavBar(tester);
      await _navigateToProfileScreen(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}
