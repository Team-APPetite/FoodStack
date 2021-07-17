import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/utilities/time.dart';

void main() {
  group('Calculate minutes remaining', () {
    test('Current time is equal to Completion time', () {
      final value = TimeHelper.minutesRemaining(DateTime.now(), DateTime.now());
      expect(value, 0);
    });

    test('Current time is earlier than Completion time', () {
      final value = TimeHelper.minutesRemaining(
          DateTime.now().add(Duration(minutes: 6, seconds: 20)),
          DateTime.now());
      expect(value, 6);
    });

    test('Current time is later than Completion time', () {
      final value = TimeHelper.minutesRemaining(
          DateTime.now().subtract(Duration(minutes: 18, seconds: 3)),
          DateTime.now());
      expect(value, -18);
    });
  });

  group('Time formatting', () {
    test('Format timings with minutes > 9', () {
      final value = TimeHelper.formatTime(DateTime.utc(2021, 3, 21, 4, 34));
      expect(value, '4:34');
    });

    test('Format timings with minutes <= 9', () {
     final value = TimeHelper.formatTime(DateTime.utc(2021, 3, 21, 16, 1));
      expect(value, '16:01'); 
    });
  });
}
