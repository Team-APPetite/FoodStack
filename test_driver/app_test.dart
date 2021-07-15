// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart' hide find;

void main() {
  group('FoodStack', () {

    // Login screen
    final loginEmail = find.byValueKey('loginEmail');
    final loginPassword = find.byValueKey('loginPassword');
    final loginButton = find.byValueKey('loginButton');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });
  });
}