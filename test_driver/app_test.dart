import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group(
    'FoodStack',
    () {
      // Login screen
      final loginEmail = find.byValueKey('loginEmail');
      final loginPassword = find.byValueKey('loginPassword');
      final loginButton = find.byValueKey('loginButton');

      // Bottom Navigation Bar
      final bottomNavigationBar = find.byValueKey('bottomNavigationBar');
      final navigateToProfileScreen =
          find.byValueKey('navigateToProfileScreen');

      // Home Screen
      final newOrder = find.byValueKey('NewOrder');

      // Profile Screen
      final logoutButton = find.byValueKey('logoutButton');

      // New Order
      final restaurant = find.byValueKey('restaurant0');

      // Menu
      final addItem0ToCart = find.byValueKey('addToCart0');
      final addItem1ToCart = find.byValueKey('addToCart1');
      final viewCartButton = find.byValueKey('viewCartButton');

      // Cart screen
      final joinDurationScrollable = find.byValueKey('joinDurationScrollable');
      final confirmCartButton = find.byValueKey('confirmCartButton');

      // Wait screen
      final checkoutButton = find.byValueKey('checkoutButton');

      // Checkout screen
      final cashOnDeliveryOption = find.byValueKey('paymentOption1');
      final payButton = find.byValueKey('payButton');

      // Order confirmation screen
      final trackOrderButton = find.byValueKey('trackOrderButton');

      FlutterDriver driver;

      Future<bool> isPresent(SerializableFinder byValueKey,
          {Duration timeout = const Duration(seconds: 5)}) async {
        try {
          await driver.waitFor(byValueKey, timeout: timeout);
          return true;
        } catch (exception) {
          return false;
        }
      }

      setUpAll(() async {
        final envVars = Platform.environment;
        print(envVars);
        final adbPath = join(
          envVars['ANDROID_SDK_ROOT'] ?? envVars['ANDROID_HOME'],
          'platform-tools',
          Platform.isWindows ? 'adb.exe' : 'adb',
        );
        await Process.run(adbPath, [
          'shell',
          'pm',
          'grant',
          'com.charismakausar.foodstack',
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.INTERNET',
          'android.permission.VIBRATE',
          'android.permission.RECEIVE_BOOT_COMPLETED'
        ]);
        driver = await FlutterDriver.connect();
      });

      tearDownAll(() async {
        if (driver != null) {
          driver.close();
        }
      });

      test('Login', () async {
        if (await isPresent(bottomNavigationBar)) {
          await driver.tap(navigateToProfileScreen);
          await driver.waitFor(find.text('Profile'));
          await driver.tap(logoutButton);
          await driver.waitFor(find.text('FoodStack'));
        }

        await driver.tap(loginEmail);
        await driver.enterText('demouser@email.com');

        await driver.tap(loginPassword);
        await driver.enterText('123456');

        await driver.tap(loginButton);
        await driver.waitFor(find.text('Hungry? Order Now'));
      },
          timeout: Timeout(
            Duration(minutes: 2),
          ));

      test('Add items to cart', () async {
        await driver.waitFor(find.text('Hungry? Order Now'));
        await driver.tap(newOrder);
        await driver.waitFor(find.text('Start a New Order'));
        await driver.tap(restaurant);
        await driver.waitFor(find.text('VIEW CART'));
        await driver.tap(addItem0ToCart);
        await driver.tap(addItem0ToCart);
        await driver.waitFor(find.text('x2'));
        await driver.tap(addItem1ToCart);
        await driver.waitFor(find.text('x1'));
        await driver.waitFor(find.text('3'));
        await driver.tap(viewCartButton);
      },
          timeout: Timeout(
            Duration(minutes: 2),
          ));

      test('Place order', () async {
        await driver.waitFor(find.text('CONFIRM CART'));
        await driver.scrollUntilVisible(joinDurationScrollable, find.text('0'),
            dyScroll: 25, alignment: 20);
        await driver.tap(confirmCartButton);
        await driver.waitFor(find.text('CHECKOUT'));
        await driver.tap(checkoutButton);
        await driver.waitFor(find.text('Checkout'));
        await driver.tap(cashOnDeliveryOption);
        await driver.tap(payButton);
        await driver.waitFor(find.text('Your order has been confirmed!'));
        await driver.tap(trackOrderButton);
        await driver.waitFor(find.text('Track Your Order'));
        await driver.waitFor(bottomNavigationBar);
      },
          timeout: Timeout(
            Duration(minutes: 2),
          ));

      test('Logout', () async {
        await driver.waitFor(bottomNavigationBar);
        await driver.tap(navigateToProfileScreen);
        await driver.waitFor(find.text('Profile'));
        await driver.tap(logoutButton);
        await driver.waitFor(find.text('FoodStack'));
      },
          timeout: Timeout(
            Duration(minutes: 2),
          ));
    },
  );
}
