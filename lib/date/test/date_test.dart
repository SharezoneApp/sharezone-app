import 'package:date/date.dart';
import 'package:test/test.dart';

void main() {
  group(Date, () {
    test('compareTo', () {
      final today = Date('2025-10-11');
      final tomorrow = today.addDays(1);
      expect(today.compareTo(tomorrow), -1);
    });
  });
}
