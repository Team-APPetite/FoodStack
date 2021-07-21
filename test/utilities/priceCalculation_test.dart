import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/utilities/priceCalculation.dart';

void main() {
  group('Price Calculation', () {
    test('One person in order', () {
      final value = PriceCalculation.totalFee(18.90, 6.5, 1);
      expect(value, 25.4);
    });

    test('Multiple people in order', () {
      final value = PriceCalculation.totalFee(18.90, 6.5, 5);
      expect(value, 20.2);
    });

    test('Rounding non terminating numbers', () {
      final value = PriceCalculation.totalFee(18.90, 6.5, 4);
      expect(value, 20.53);
    });

  });
}