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
      const term1Id = TermId('term-1');
      const term2Id = TermId('term-2');
      const subject1Id = SubjectId('subject-1');
      const subjectDoNotDeleteId = SubjectId('subject-do-not-delete');
      const grade1Id = GradeId('grade-1');
      const grade2Id = GradeId('grade-2');
      const grade3Id = GradeId('grade-3');

      testController.addSubject(
        subjectWith(id: subject1Id, name: 'Mathematik'),
      );
      testController.addSubject(
        subjectWith(id: subjectDoNotDeleteId, name: 'Physik'),
      );
      testController.createTerm(termWith(id: term1Id));
      testController.createTerm(termWith(id: term2Id));
      testController.addGrade(
        subjectId: subject1Id,
        termId: term1Id,
        value: gradeWith(id: grade1Id, title: 'Klausur 1'),
      );
      testController.addGrade(
        subjectId: subject1Id,
        termId: term2Id,
        value: gradeWith(id: grade2Id, title: 'Klausur 2'),
      );
      testController.addGrade(
        subjectId: subjectDoNotDeleteId,
        termId: term1Id,
        value: gradeWith(id: grade3Id, title: 'Klausur 3'),
      );

      expect(
        service.getSubjects().any((subject) => subject.id == subject1Id),
        isTrue,
      );

      service.deleteSubject(subject1Id);

      expect(
        service.getSubjects().any((subject) => subject.id == subject1Id),
        isFalse,
      );

      expect(testController.term(term1Id).subjects.map((s) => s.id), [
        // Subject 'subject-do-not-delete' should not be deleted and should
        // still be part of term 1
        subjectDoNotDeleteId,
      ]);
      expect(testController.term(term2Id).subjects, isEmpty);
      expect(
        () => service.grade(grade1Id),
        throwsA(isA<GradeNotFoundException>()),
      );
      expect(
        () => service.grade(grade2Id),
        throwsA(isA<GradeNotFoundException>()),
      );
      // Grade 3 should not be deleted because it's part of subject
      // 'subject-do-not-delete'
      expect(service.grade(grade3Id).get(), isNotNull);
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
