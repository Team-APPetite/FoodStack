import 'package:test/test.dart';
import 'package:foodstack/src/screens/authentication/signup.dart';

void main() {
  group('Sign Up', () {
    test('Invalid Email', () {
      final value = SignUpFunction().signup("abc", "xyz", "rst", "abc", "abc");
      expect(value,throwsA(isA<Error>()));
    });

    // test('Round down non-terminating decimal numbers', () {
    //   final value = Numbers.roundTo2d(10/3);
    //   expect(value, 3.33);
    // });
    //
    // test('Round up non-terminating decimal numbers', () {
    //   final value = Numbers.roundTo2d(20/3);
    //   expect(value, 6.67);
    // });
  });
}