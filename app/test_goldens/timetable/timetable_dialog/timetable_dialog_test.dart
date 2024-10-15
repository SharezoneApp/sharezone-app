// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../test/homework/homework_dialog_test.dart';
import '../../../test/homework/homework_dialog_test.mocks.dart';
import '../../../test/timetable/timetable_dialog_test.mocks.dart';
import '../../../test/timetable/timetable_dialog_tester.dart';

void main() {
  group('event add dialog', () {
    late MockEventDialogApi api;
    late MockSharezoneGateway sharezoneGateway;
    late MockCourseGateway courseGateway;
    late MockSharezoneContext sharezoneContext;

    setUp(() {
      sharezoneGateway = MockSharezoneGateway();
      courseGateway = MockCourseGateway();
      sharezoneContext = MockSharezoneContext();
      api = MockEventDialogApi();
    });

    TimetableDialogTester createDialogTester(WidgetTester tester) {
      return TimetableDialogTester(
        tester: tester,
        api: api,
        sharezoneContext: sharezoneContext,
        courseGateway: courseGateway,
        sharezoneGateway: sharezoneGateway,
      );
    }

    var lightTheme = (data: getLightTheme(), name: 'light');
    var darkTheme = (data: getDarkTheme(), name: 'dark');

    for (var testConfig in [
      (isExam: true, theme: lightTheme),
      (isExam: true, theme: darkTheme),
      (isExam: false, theme: lightTheme),
      (isExam: false, theme: darkTheme),
    ]) {
      testGoldens(
          'renders empty event dialog as expected (${testConfig.theme.name}, isExam: ${testConfig.isExam})',
          (tester) async {
        final dt = createDialogTester(tester);
        dt.addCourse(courseWith(id: 'fooId', name: 'Foo course'));

        await withClock(Clock.fixed(DateTime(2024, 2, 22)), () async {
          await dt.pumpDialog(
            isExam: testConfig.isExam,
            theme: testConfig.theme.data,
          );
        });

        await multiScreenGolden(
          tester,
          'event_dialog_add_empty_${testConfig.theme.name}_${testConfig.isExam ? 'exam' : 'event'}',
        );
      });

      testGoldens(
          'renders full event dialog as expected (${testConfig.theme.name}, isExam: ${testConfig.isExam})',
          (tester) async {
        final dt = createDialogTester(tester);
        dt.addCourse(courseWith(id: 'fooId', name: 'Foo course'));

        await withClock(Clock.fixed(DateTime(2024, 2, 22)), () async {
          await dt.pumpDialog(
            isExam: testConfig.isExam,
            theme: testConfig.theme.data,
          );
        });

        await dt.enterTitle('Test title');
        await dt.selectCourse('Foo course');
        await withClock(
          Clock.fixed(
            DateTime(2022, 1, 1),
          ),
          () async {
            await dt.selectDate(dayOfCurrentMonth: '10');
          },
        );
        await dt.enterDescription('Test description');
        await dt.enterLocation('M12');
        await dt.tapNotifyCourseMembersSwitch();

        await multiScreenGolden(
          tester,
          'event_dialog_add_full_${testConfig.theme.name}_${testConfig.isExam ? 'exam' : 'event'}',
        );
      });

      testGoldens(
          'renders error event dialog as expected (${testConfig.theme.name}, isExam: ${testConfig.isExam})',
          (tester) async {
        final dt = createDialogTester(tester);

        await withClock(Clock.fixed(DateTime(2024, 2, 22)), () async {
          await dt.pumpDialog(
            isExam: testConfig.isExam,
            theme: testConfig.theme.data,
          );
        });

        // Set end time before start time.
        await dt.selectStartTime(const TimeOfDay(hour: 12, minute: 0));
        await dt.selectEndTime(const TimeOfDay(hour: 10, minute: 0));

        // Triggers "empty title", "no course chosen" and "end time is before start time" error messages.
        await dt.tapSaveButton();

        await multiScreenGolden(
          tester,
          'event_dialog_add_error_${testConfig.theme.name}_${testConfig.isExam ? 'exam' : 'event'}',
        );
      });
    }
  });
}
