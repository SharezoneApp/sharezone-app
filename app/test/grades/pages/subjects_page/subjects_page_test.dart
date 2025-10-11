// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller_factory.dart';

import '../../grades_test_common.dart';

void main() {
  group(SubjectsPage, () {
    late GradesService service;
    late GradesTestController testController;

    setUp(() {
      service = GradesService();
      testController = GradesTestController(gradesService: service);
    });

    testWidgets('shows subjects and allows deleting them', (tester) async {
      const termId = TermId('term');
      const termName = '11/1';
      const subjectId = SubjectId('subject');

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
                  id: const GradeId('grade'),
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

      final factory = SubjectsPageControllerFactory(
        gradesService: service,
        coursesStream: () => Stream.value([
          _course(id: 'math', subject: 'Mathematik', name: 'Mathe Kurs'),
          _course(id: 'bio', subject: 'Biologie', name: 'Bio Kurs'),
        ]),
      );

      await tester.pumpWidget(
        Provider<SubjectsPageControllerFactory>.value(
          value: factory,
          child: const MaterialApp(home: SubjectsPage()),
        ),
      );

      await tester.pump();

      expect(find.text('Mathematik'), findsOneWidget);
      expect(find.textContaining('Kurse: Bio Kurs'), findsOneWidget);

      await tester.tap(find.byTooltip('Fach löschen'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Klausur 1'), findsOneWidget);
      expect(find.textContaining(termName), findsOneWidget);
      expect(find.textContaining('Schriftliche Prüfung'), findsOneWidget);
      expect(find.text('5'), findsWidgets);

      await tester.tap(find.widgetWithText(FilledButton, 'Löschen'));
      await tester.pump();

      expect(find.text('Fach und zugehörige Noten gelöscht.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Noch keine Fächer angelegt'), findsOneWidget);
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
