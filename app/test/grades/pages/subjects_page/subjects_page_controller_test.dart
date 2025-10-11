// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller.dart';

import '../../grades_test_common.dart';

void main() {
  group(SubjectsPageController, () {
    late GradesService service;
    late GradesTestController testController;
    late StreamController<List<Course>> coursesController;

    setUp(() {
      service = GradesService();
      testController = GradesTestController(gradesService: service);
      coursesController = StreamController<List<Course>>();
    });

    tearDown(() async {
      await coursesController.close();
    });

    test('builds view with grade subjects and courses without subjects', () async {
      const termId = TermId('term-1');
      const subjectId = SubjectId('subject-1');
      const gradeId = GradeId('grade-1');
      const termName = '11/1';

      testController.createTerm(
        termWith(
          id: termId,
          name: termName,
          subjects: [
            subjectWith(
              id: subjectId,
              name: 'Mathematik',
              abbreviation: 'MA',
              grades: [
                gradeWith(
                  id: gradeId,
                  value: 5,
                  gradingSystem: GradingSystem.zeroToFifteenPoints,
                  title: 'Klausur 1',
                  type: GradeType.writtenExam.id,
                ),
              ],
            ),
          ],
        ),
      );

      final controller = SubjectsPageController(
        gradesService: service,
        coursesStream: coursesController.stream,
      );

      addTearDown(controller.dispose);

      await pumpEventQueue();
      expect(controller.state, isA<SubjectsPageLoaded>());

      final firstView = (controller.state as SubjectsPageLoaded).view;
      expect(firstView.gradeSubjects, hasLength(1));
      final subjectView = firstView.gradeSubjects.first;
      expect(subjectView.name, 'Mathematik');
      expect(subjectView.grades, hasLength(1));
      expect(subjectView.grades.first.displayValue, '5');
      expect(subjectView.grades.first.termName, termName);
      expect(subjectView.grades.first.gradeTypeName, 'Schriftliche Prüfung');

      coursesController.add([
        _course(
          id: 'course-math',
          subject: 'Mathematik',
          name: 'Mathe Kurs',
        ),
        _course(
          id: 'course-bio',
          subject: 'Biologie',
          name: 'Bio Kurs',
        ),
      ]);

      await pumpEventQueue();

      expect(controller.state, isA<SubjectsPageLoaded>());
      final updatedView = (controller.state as SubjectsPageLoaded).view;
      expect(updatedView.gradeSubjects, hasLength(1));
      expect(updatedView.coursesWithoutSubject, hasLength(1));
      expect(updatedView.coursesWithoutSubject.first.name, 'Biologie');
      expect(
        updatedView.coursesWithoutSubject.first.connectedCourses.first.name,
        'Bio Kurs',
      );
    });
  });
}

Course _course({required String id, required String subject, String? name}) {
  return Course.create().copyWith(
    id: id,
    name: name ?? subject,
    subject: subject,
    abbreviation: subject.isNotEmpty ? subject.substring(0, 1).toUpperCase() : 'C',
    myRole: MemberRole.admin,
  );
}
