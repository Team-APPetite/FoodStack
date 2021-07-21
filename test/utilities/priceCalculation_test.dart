import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/utilities/priceCalculation.dart';

void main() {
  group('Total Fee Calculation', () {
    test('One person in order', () {
      final value = PriceCalculation.totalFee(18.90, 6.5, 1);
      expect(value, 25.4);
    });

    test('Multiple people in order', () {
      final value = PriceCalculation.totalFee(18.90, 6.5, 5);
      expect(value, 20.2);
    });

    test('Rounding numbers', () {
      final value = PriceCalculation.totalFee(18.90, 6.5, 4);
      expect(value, 20.53);
    });

    test('Delivery fee is null', () {
      final value = PriceCalculation.totalFee(18.90, null, 4);
      expect(value, 0);
    });
  });

  group('Amount Saved Calculation', () {
    test('One person in order', () {
      final value = PriceCalculation.getAmountSaved(6.5, 1);
      expect(value, 0);
    });

    test('Multiple people in order', () {
      final value = PriceCalculation.getAmountSaved(6.5, 5);
      expect(value, 5.2);
    });

    test('Rounding numbers', () {
      final value = PriceCalculation.getAmountSaved(6.5, 4);
      expect(value, 4.87);
    });

    test('Delivery fee is null', () {
      final value = PriceCalculation.getAmountSaved(null, 4);
      expect(value, 0);
    });
  });
}
