import 'package:flutter_test/flutter_test.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/subject.dart';
import 'package:hausaufgabenheft_logik/src/shared/color.dart';

void main() {
  group('Subject Tests', () {
    test('Subject throws ArgumentError if name is empty', () {
      expect(
        () => Subject('', abbreviation: 'M', color: const Color(0xFF000000)),
        throwsArgumentError,
      );
    });

    test('Subject instantiates correctly with valid name', () {
      final subject = Subject('Math', abbreviation: 'M', color: const Color(0xFF000000));
      expect(subject.name, 'Math');
      expect(subject.abbreviation, 'M');
      expect(subject.color, const Color(0xFF000000));
    });
  });
}
