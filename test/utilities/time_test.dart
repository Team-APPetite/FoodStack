import 'package:test/test.dart';
import 'package:foodstack/src/utilities/time.dart';

void main() {
  group('Calculate minutes remaining', () {

    test('Current time is equal to Completion time', () {
      final value = TimeHelper.minutesRemaining(DateTime.now(), DateTime.now());
      expect(value, 0);
    });

  });
}