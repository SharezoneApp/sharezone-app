import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/date.dart';

void main() {
  group('Date Tests', () {
    test('Date.now() uses clock', () {
      withClock(Clock.fixed(DateTime(2023, 10, 15, 12, 30)), () {
        final date = Date.now();
        expect(date.year, 2023);
        expect(date.month, 10);
        expect(date.day, 15);
      });
    });

    test('addDays correctly wraps months and years', () {
      final date = const Date(day: 31, month: 12, year: 2023);
      final nextDay = date.addDays(1);

      expect(nextDay.day, 1);
      expect(nextDay.month, 1);
      expect(nextDay.year, 2024);
    });

    test('compareTo orders dates correctly', () {
      final earlier = const Date(day: 14, month: 10, year: 2023);
      final laterDay = const Date(day: 15, month: 10, year: 2023);
      final laterMonth = const Date(day: 14, month: 11, year: 2023);
      final laterYear = const Date(day: 14, month: 10, year: 2024);

      expect(earlier.compareTo(laterDay), lessThan(0));
      expect(earlier.compareTo(laterMonth), lessThan(0));
      expect(earlier.compareTo(laterYear), lessThan(0));

      expect(laterDay.compareTo(earlier), greaterThan(0));
      expect(earlier.compareTo(earlier), equals(0));
    });

    test('Operators > and < work correctly', () {
      final earlier = const Date(day: 1, month: 1, year: 2023);
      final later = const Date(day: 2, month: 1, year: 2023);

      expect(later > earlier, isTrue);
      expect(earlier < later, isTrue);
      expect(earlier > later, isFalse);
      expect(later < earlier, isFalse);
    });
  });
}
