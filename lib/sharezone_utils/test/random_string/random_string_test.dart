import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_utils/random_string.dart';

void main() {
  test('randomString()', () {
    for (int i = 0; i < 50; i++) {
      expect(randomString(10), hasLength(10));
    }
  });

  test('randomIDString()', () {
    for (int i = 0; i < 50; i++) {
      expect(randomIDString(10), hasLength(10));
    }
  });
}
