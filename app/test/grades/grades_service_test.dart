// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
  });
}
