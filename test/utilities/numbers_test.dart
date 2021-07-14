import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/utilities/numbers.dart';

void main() {
  group('Round to 2 decimal places', () {
    test('Round terminating decimal numbers', () {
      final value = Numbers.roundTo2d(2.69999999999);
      expect(value, 2.7);
    });

    test('Round down non-terminating decimal numbers', () {
      final value = Numbers.roundTo2d(10/3);
      expect(value, 3.33);
    });

    test('Round up non-terminating decimal numbers', () {
      final value = Numbers.roundTo2d(20/3);
      expect(value, 6.67);
    });
  });
}