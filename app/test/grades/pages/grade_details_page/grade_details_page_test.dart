// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller_factory.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_view.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller_factory.dart';

import '../grades_dialog/grades_dialog_controller_test.dart';
import 'grade_details_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GradeDetailsPageController>(),
  MockSpec<GradeDetailsPageControllerFactory>(),
  MockSpec<GradesDialogControllerFactory>(),
])
void main() {
  const id = GradeId('1');

  late MockGradeDetailsPageControllerFactory controllerFactory;
  late MockGradeDetailsPageController controller;

  void setState(GradeDetailsPageState state) {
    // Mockito does not support mocking sealed classes yet, so we have to
    // provide a dummy implementation of the state.
    //
    // Ticket: https://github.com/dart-lang/mockito/issues/675
    provideDummy<GradeDetailsPageState>(state);
    when(controller.state).thenReturn(state);
  }

  void setLoaded() {
    const dummyView = GradeDetailsView(
      gradeValue: '5',
      gradingSystem: '5-Point',
      subjectDisplayName: 'Math',
      date: '2021-09-01',
      gradeType: 'Test',
      termDisplayName: '1st Term',
      integrateGradeIntoSubjectGrade: true,
      title: 'Algebra',
      details: 'This is a test grade for algebra.',
    );
    setState(const GradeDetailsPageLoaded(dummyView));
  }

  setUp(() {
    controllerFactory = MockGradeDetailsPageControllerFactory();
    controller = MockGradeDetailsPageController();
    when(controller.id).thenReturn(id);
    when(controllerFactory.create(id)).thenReturn(controller);
    setLoaded();
  });

  group(GradeDetailsPage, () {
    Future<void> pushGradeDetailsPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<GradeDetailsPageControllerFactory>.value(
              value: controllerFactory,
            ),
            ChangeNotifierProvider<GradeDetailsPageController>(
              create: (context) => controller,
            ),
            Provider<GradesDialogControllerFactory>.value(
              value: GradesDialogControllerFactory(
                analytics: MockAnalytics(),
                coursesStream: () => Stream.empty(),
                gradesService: GradesService(),
                crashAnalytics: MockCrashAnalytics(),
              ),
            ),
          ],
          child: MaterialApp(
            routes: {
              GradesDialog.tag: (context) {
                if (ModalRoute.of(context)!.settings.arguments case {
                  'gradeId': String id,
                }) {
                  return GradesDialog(gradeId: GradeId(id));
                }
                return const GradesDialog();
              },
            },
            home: const GradeDetailsPage(id: id),
          ),
        ),
      );
    }

    testWidgets(
      'should show grades editing dialog with selected grade when edit icon is tapped',
      (tester) async {
        await pushGradeDetailsPage(tester);

        await tester.tap(find.byKey(const Key('edit-grade-icon-button')));
        await tester.pumpAndSettle();

        expect(find.byType(GradesDialog), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is GradesDialog && widget.gradeId == id,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('should delete grade when confirmed', (tester) async {
      await pushGradeDetailsPage(tester);

      await tester.tap(find.byKey(const Key('delete-grade-icon-button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('delete-grade-confirmation-dialog-delete-button')),
      );
      await tester.pumpAndSettle();

      verify(controller.deleteGrade()).called(1);
    });

    testWidgets('should not delete grade when canceled', (tester) async {
      await pushGradeDetailsPage(tester);

      await tester.tap(find.byKey(const Key('delete-grade-icon-button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('delete-grade-confirmation-dialog-cancel-button')),
      );
      await tester.pumpAndSettle();

      verifyNever(controller.deleteGrade());
    });
  });
}
