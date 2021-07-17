import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('FoodStack', () {
    // Login screen
    final loginEmail = find.byValueKey('loginEmail');
    final loginPassword = find.byValueKey('loginPassword');
    final loginButton = find.byValueKey('loginButton');

    // Bottom Navigation Bar
    final bottomNavigationBar = find.byValueKey('bottomNavigationBar');
    final navigateToProfileScreen = find.byValueKey('navigateToProfileScreen');

    // Profile Screen
    final logoutButton = find.byValueKey('logoutButton');

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
        'android.permission.ACCESS_FINE_LOCATION'
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
        print("btm nav bar present");
        await driver.tap(navigateToProfileScreen);
        await driver.waitFor(find.text('Profile'));
        await driver.tap(logoutButton);
        await driver.waitFor(find.text('FoodStack'));
      }

      await driver.tap(loginEmail);
      await driver.enterText('appfoodstack@gmail.com');

      await driver.tap(loginPassword);
      await driver.enterText('123456');

      await driver.tap(loginButton);
      await driver.waitFor(find.text('Hungry? Order Now'));
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
    });
  },
      timeout: Timeout(
        Duration(minutes: 2),
      ));
}
