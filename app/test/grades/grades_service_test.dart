// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

import 'grades_test_common.dart';

void main() {
  group('$GradesService', () {
    late GradesService service;
    late GradesTestController testController;

    setUp(() {
      service = GradesService();
      testController = GradesTestController(gradesService: service);
    });

    test('$GradeRef.get does not throw if not existing', () {
      testController.createTerm(
        termWith(
          id: const TermId('term1'),
          subjects: [
            subjectWith(id: const SubjectId('subject1'), grades: [gradeWith()]),
          ],
        ),
      );

      expect(
        service
            .term(const TermId('term1'))
            .subject(const SubjectId('subject1'))
            .grade(const GradeId('not-existing'))
            .get(),
        isNull,
      );
    });

    test('deleteSubject removes subject and grades from all terms', () {
      const termId = TermId('term-1');
      const subjectId = SubjectId('subject-1');
      const gradeId = GradeId('grade-1');

      testController.createTerm(
        termWith(
          id: termId,
          subjects: [
            subjectWith(
              id: subjectId,
              name: 'Mathematik',
              grades: [gradeWith(id: gradeId, title: 'Klausur')],
            ),
          ],
        ),
      );

      expect(
        service.getSubjects().any((subject) => subject.id == subjectId),
        isTrue,
      );

      service.deleteSubject(subjectId);

      expect(
        service.getSubjects().any((subject) => subject.id == subjectId),
        isFalse,
      );

      final term = service.terms.value.singleWhere((t) => t.id == termId);
      expect(term.subjects.any((s) => s.id == subjectId), isFalse);
      expect(
        () => service.grade(gradeId),
        throwsA(isA<GradeNotFoundException>()),
      );
    });

    test('deleteSubject succeeds even if subject not part of any term', () {
      const orphanSubjectId = SubjectId('subject-orphan');
      service.addSubject(
        SubjectInput(
          name: 'Physik',
          abbreviation: 'PH',
          design: Design.standard(),
          connectedCourses: const IListConst([]),
        ),
        id: orphanSubjectId,
      );

      expect(
        service.getSubjects().any((subject) => subject.id == orphanSubjectId),
        isTrue,
      );

      service.deleteSubject(orphanSubjectId);

      expect(
        service.getSubjects().any((subject) => subject.id == orphanSubjectId),
        isFalse,
      );
    });

    test('deleteSubject throws if subject does not exist', () {
      expect(
        () => service.deleteSubject(const SubjectId('unknown')),
        throwsA(isA<SubjectNotFoundException>()),
      );
    });
  });
}
