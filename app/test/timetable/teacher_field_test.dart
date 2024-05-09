// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/timetable_edit/lesson/timetable_lesson_edit_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'teacher_field_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionService>()])
void main() {
  group(TeacherField, () {
    late MockSubscriptionService mockSubscriptionService;
    const initialTeacher = "Mrs. Stark";
    final teachersList = ISet(const ['Mrs. Stark', 'Mr. Rogers', 'Ms. Lee']);

    setUp(() {
      mockSubscriptionService = MockSubscriptionService();
    });

    Widget buildWidget({bool isUnlocked = true}) {
      when(mockSubscriptionService
              .hasFeatureUnlocked(SharezonePlusFeature.addTeachersToTimetable))
          .thenReturn(isUnlocked);
      return Provider<SubscriptionService>.value(
        value: mockSubscriptionService,
        child: MaterialApp(
          home: Scaffold(
            body: TeacherField(
              initialTeacher: initialTeacher,
              teachers: teachersList,
              onTeacherChanged: (teacher) {},
            ),
          ),
        ),
      );
    }

    testWidgets('should show initial teacher value',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text(initialTeacher), findsOneWidget);
    });

    testWidgets('should related teachers in autocomplete menu',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.enterText(find.byType(TextField), 'Rog');

      await tester.pumpAndSettle();

      expect(find.text('Mr. Rogers'), findsOneWidget);
      expect(find.text('Ms. Lee'), findsNothing);
    });

    testWidgets('should take selected value from autocomplete menu',
        (WidgetTester tester) async {
      String selectedTeacher = '';
      await tester.pumpWidget(Provider<SubscriptionService>.value(
        value: mockSubscriptionService,
        child: MaterialApp(
          home: Scaffold(
            body: TeacherField(
              teachers: teachersList,
              onTeacherChanged: (teacher) {
                selectedTeacher = teacher;
              },
            ),
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Mrs.');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mrs. Stark'));
      await tester.pumpAndSettle();

      expect(selectedTeacher, equals('Mrs. Stark'));
    });

    testWidgets('should ignore interaction when Locked',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(isUnlocked: false));

      expect(
          tester
              .widget<IgnorePointer>(
                  find.byKey(const Key('teacher-ignore-pointer-widget')))
              .ignoring,
          isTrue);
    });

    testWidgets('show allow interactions when unlocked',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(isUnlocked: true));

      expect(
          tester
              .widget<IgnorePointer>(
                  find.byKey(const Key('teacher-ignore-pointer-widget')))
              .ignoring,
          isFalse);
    });

    testWidgets(
        'should show showTeachersInTimetablePlusDialog when non plus user taps on teacher field',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(isUnlocked: false));

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should show Sharezone Plus chip for non plus users',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildWidget(isUnlocked: false));

      expect(find.byType(SharezonePlusChip), findsOneWidget);
    });
  });
}
