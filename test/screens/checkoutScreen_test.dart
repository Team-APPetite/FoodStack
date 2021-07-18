import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/paymentProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/screens/orderSummary.dart';
import 'package:foodstack/src/services/braintreeService.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mock.dart';

String result;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockBraintreeService extends Mock implements BraintreeService {
  Future<String> makePayment(double amount, String payee) async {
    if (result != null) {
      if (result == 'Success') {
        return "Payment successful!";
      } else {
        return "Unsuccessful transaction, Please try again";
      }
    } else {
      return "Please make payment for your order";
    }
  }
}

void main() async {
  setupFirebaseAuthMocks();
  MockBraintreeService mockBraintreeService = MockBraintreeService();

  tearDown(() {});

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
            home: CheckoutScreen(mockBraintreeService),
            navigatorObservers: [mockObserver],
            routes: {
              '/orderSummary': (context) => SummaryScreen(),
            },
          )));
    }

    Future<void> _payOnline(WidgetTester tester) async {
      final payOnlineOption = find.byKey(ValueKey('paymentOption0'));
      final payButton = find.byKey(ValueKey('payButton'));
      await tester.tap(payOnlineOption);
      await tester.tap(payButton);
      await tester.pump();
      await tester.pump();
    }

    testWidgets('Successful payment', (WidgetTester tester) async {
      result = 'Success';
      await _buildCheckoutScreen(tester);
      await _payOnline(tester);

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SummaryScreen), findsOneWidget);
    });

    testWidgets('Unsuccessful transaction', (WidgetTester tester) async {
      result = 'Error';
      await _buildCheckoutScreen(tester);
      await _payOnline(tester);
      expect(find.byType(SummaryScreen), findsNothing);
    });

    testWidgets('Online payment cancelled', (WidgetTester tester) async {
      result = null;
      await _buildCheckoutScreen(tester);
      await _payOnline(tester);
      expect(find.byType(SummaryScreen), findsNothing);
    });
  });
}
