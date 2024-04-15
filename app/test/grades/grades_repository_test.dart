import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

void main() {
  group('GradesRepository', () {
    test('serializes expected data map for empty state', () {
      final res = FirestoreGradesRepository.toDto((
        customGradeTypes: const IListConst([]),
        subjects: const IListConst([]),
        terms: const IListConst([]),
      ));

      expect(res, {
        'customGradeTypes': {},
        'subjects': {},
        'grades': {},
        'terms': {},
      });
    });
    test('deserializes expected state from data map', () {
      final res = FirestoreGradesRepository.fromData({
        'customGradeTypes': {},
        'subjects': {},
        'grades': {},
        'terms': {},
      });

      expect(res, (
        customGradeTypes: const IListConst([]),
        subjects: const IListConst([]),
        terms: const IListConst([]),
      ));
    });
  });
}
