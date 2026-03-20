// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';

import '../../grades_test_common.dart';

void main() {
  group('$TermSettingsPageController', () {
    test(
      'setSubjectWeight creates a missing subject and updates the weight',
      () async {
        const termId = TermId('term-id');
        const courseId = 'course-id';
        final service = GradesService();
        final testController = GradesTestController(gradesService: service);
        testController.createTerm(termWith(id: termId));

        final controller = TermSettingsPageController(
          gradesService: service,
          termRef: service.term(termId),
          coursesStream: Stream.value([
            Course.create().copyWith(
              id: courseId,
              name: 'English LK',
              subject: 'English',
              abbreviation: 'EN',
            ),
          ]),
        );

        await Future<void>.delayed(Duration.zero);
        await controller.setSubjectWeight(
          const SubjectId(courseId),
          const Weight.factor(2),
        );

        final termSubject = testController
            .term(termId)
            .subjects
            .singleWhere((subject) => subject.name == 'English');
        expect(termSubject.weightingForTermGrade, const Weight.factor(2));

        controller.dispose();
      },
    );
  });
}
