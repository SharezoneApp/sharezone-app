import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';
import 'package:sharezone/grades/pages/grades_view.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';

import '../../test_goldens/grades/pages/grades_page/grades_page_test.mocks.dart';
import '../homework/homework_dialog_test.dart';

void main() {
  group('Grades Page', () {
    testWidgets('Creating a simple term works', (tester) async {
      await pumpGradesPage(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(const ValueKey('add-term-tile')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('term-name-field')), 'Halbjahr 01/2022');
      await tester.tap(find.byKey(const ValueKey('save-button')));
      await tester.pumpAndSettle();

      expect(find.text('Halbjahr 01/2022'), findsOneWidget);
    });
  });
}

Future<void> pumpGradesPage(WidgetTester tester) async {
  final controller = MockGradesPageController();
  final state = GradesPageLoaded(
    currentTerm: currentTerm,
    pastTerms: pastTerms,
  );
  // Mockito does not support mocking sealed classes yet, so we have to
  // provide a dummy implementation of the state.
  //
  // Ticket: https://github.com/dart-lang/mockito/issues/675
  provideDummy<GradesPageState>(state);
  when(controller.state).thenReturn(state);

  await tester.pumpWidget(BlocProvider(
    bloc: NavigationBloc(),
    child: MultiProvider(
      providers: [
        Provider<GradesService>(
          create: (context) => GradesService(),
        ),
        ChangeNotifierProvider<GradesPageController>(
          create: (BuildContext context) => controller,
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: GradesPageBody())),
    ),
  ));
}

final random = Random(42);
final currentTerm = (
  id: const TermId('term-0'),
  displayName: '11/1',
  avgGrade: ('1,4', GradePerformance.good),
  subjects: [
    (
      displayName: 'Deutsch',
      abbreviation: 'DE',
      grade: '2,0',
      design: Design.random(random),
      id: const SubjectId('1'),
    ),
    (
      displayName: 'Englisch',
      abbreviation: 'E',
      grade: '2+',
      design: Design.random(random),
      id: const SubjectId('2'),
    ),
    (
      displayName: 'Mathe',
      abbreviation: 'DE',
      grade: '1-',
      design: Design.random(random),
      id: const SubjectId('3'),
    ),
    (
      displayName: 'Sport',
      abbreviation: 'DE',
      grade: '1,0',
      design: Design.random(random),
      id: const SubjectId('4'),
    ),
    (
      displayName: 'Physik',
      abbreviation: 'PH',
      grade: '3,0',
      design: Design.random(random),
      id: const SubjectId('5'),
    ),
  ]
);
final pastTerms = [
  (
    id: const TermId('term-1'),
    displayName: '10/2',
    avgGrade: ('1,0', GradePerformance.good),
  ),
  (
    id: const TermId('term-3'),
    displayName: '9/2',
    avgGrade: ('1,0', GradePerformance.good),
  ),
  (
    id: const TermId('term-2'),
    displayName: '10/1',
    avgGrade: ('2,4', GradePerformance.satisfactory),
  ),
  (
    id: const TermId('term-6'),
    displayName: 'Q1/1',
    avgGrade: ('2,4', GradePerformance.satisfactory),
  ),
  (
    id: const TermId('term-5'),
    displayName: '8/2',
    avgGrade: ('1,7', GradePerformance.good),
  ),
  (
    id: const TermId('term-4'),
    displayName: '9/1',
    avgGrade: ('3,7', GradePerformance.bad),
  ),
];
