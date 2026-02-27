// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller_factory.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../grades_test_common.dart';
import 'subjects_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubjectsPageControllerTranslations>()])
void main() {
  group(SubjectsPage, () {
    late GradesService service;
    late GradesTestController testController;
    late MockSubjectsPageControllerTranslations translations;

    setUp(() {
      service = GradesService();
      testController = GradesTestController(gradesService: service);
      translations = MockSubjectsPageControllerTranslations();
    });

    testWidgets('shows subjects and allows deleting them', (tester) async {
      testController.createTerm(
        termWith(
          id: const TermId('term'),
          name: '11/1',
          subjects: [
            subjectWith(
              id: const SubjectId('subject'),
              name: 'Maths',
              abbreviation: 'MA',
              grades: [
                gradeWith(
                  id: const GradeId('grade'),
                  value: 5,
                  gradingSystem: GradingSystem.zeroToFifteenPoints,
                  title: 'Exam 1',
                  type: GradeType.writtenExam.id,
                ),
              ],
              connectedCourses: [
                _course(
                  id: "math",
                  subject: "Maths",
                  name: "Maths Class",
                ).toConnectedCourse(),
              ],
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        Provider<SubjectsPageControllerFactory>.value(
          value: SubjectsPageControllerFactory(
            gradesService: service,
            coursesStream: () => Stream.value([]),
            translations: translations,
          ),
          child: const _App(),
        ),
      );

      await tester.pump();

      expect(find.text('Maths'), findsOneWidget);
      expect(find.text('1 Note · Kurse: Maths Class'), findsOneWidget);
    });

    testWidgets('shows subjects and allows deleting them', (tester) async {
      const termId = TermId('term');
      const termName = '11/1';
      const subjectId = SubjectId('subject');

      when(
        translations.predefinedTypeDisplayName(any),
      ).thenReturn('Schriftliche Prüfung');
      testController.createTerm(
        termWith(
          id: termId,
          name: termName,
          subjects: [
            subjectWith(
              id: subjectId,
              name: 'Maths',
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
        coursesStream:
            () => Stream.value([
              _course(id: 'math', subject: 'Maths', name: 'Maths Class'),
              _course(id: 'bio', subject: 'Bio', name: 'Bio Class'),
            ]),
        translations: translations,
      );

      await tester.pumpWidget(
        Provider<SubjectsPageControllerFactory>.value(
          value: factory,
          child: const _App(),
        ),
      );

      await tester.pump();

      expect(find.text('Maths'), findsOneWidget);

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

      expect(find.text('Notenfächer'), findsNothing);
    });

    testWidgets('shows error state when an error occurs', (tester) async {
      final factory = SubjectsPageControllerFactory(
        gradesService: service,
        coursesStream: () => Stream.error(Exception('Test error')),
        translations: translations,
      );

      await tester.pumpWidget(
        Provider<SubjectsPageControllerFactory>.value(
          value: factory,
          child: const _App(),
        ),
      );

      await tester.pump();

      expect(find.byType(ErrorCard), findsOneWidget);
    });
  });
}

Course _course({required String id, required String subject, String? name}) {
  return Course.create().copyWith(
    id: id,
    name: name ?? subject,
    subject: subject,
    abbreviation:
        subject.isNotEmpty ? subject.substring(0, 1).toUpperCase() : 'C',
    myRole: MemberRole.admin,
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SubjectsPage(),
      supportedLocales: [Locale('de')],
      localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
    );
  }
}

extension on Course {
  ConnectedCourse toConnectedCourse({DateTime? addedOn}) {
    return ConnectedCourse(
      id: CourseId(id),
      name: name,
      subjectName: subject,
      abbreviation: abbreviation,
      addedOn: addedOn,
    );
  }
}
