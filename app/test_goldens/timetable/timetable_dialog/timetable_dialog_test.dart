// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/timetable/timetable_add_event/src/timetable_add_event_dialog_src.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../test/homework/homework_dialog_test.dart';
import '../../../test/homework/homework_dialog_test.mocks.dart';
import '../../../test/timetable/timetable_dialog_test.mocks.dart';

void main() {
  group('event add dialog', () {
    late AddEventDialogController controller;
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

    Future<void> pumpAndSettleEventDialog(
      WidgetTester tester, {
      required bool isExam,
      required ThemeData theme,
      TimeOfDay Function()? showTimeDialogTestOverride,
    }) async {
      when(sharezoneGateway.course).thenReturn(courseGateway);
      when(sharezoneContext.api).thenReturn(sharezoneGateway);

      // Since the controller currently uses clock.now() when being created,
      // we need to move it here instead of `setUp` so that `withClock` works.
      controller = AddEventDialogController(
        api: api,
        isExam: isExam,
        markdownAnalytics: MarkdownAnalytics(Analytics(NullAnalyticsBackend())),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          blocProviders: [
            BlocProvider<SharezoneContext>(
              bloc: sharezoneContext,
            ),
          ],
          child: (context) => MaterialApp(
            home: Scaffold(
              body: TimetableAddEventDialog(
                isExam: isExam,
                controller: controller,
                showTimePickerTestOverride: showTimeDialogTestOverride,
              ),
            ),
          ),
        ),
      );
    }

    void addCourse(Course course) {
      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([course]));
      when(api.loadCourse(any)).thenAnswer((_) => Future.value(course));
      // homeworkDialogApi.addCourseForTesting(course);
    }

    Future<void> enterTitle(WidgetTester tester, String title) async {
      await tester.enterText(find.byKey(EventDialogKeys.titleTextField), title);
    }

    Future<void> selectCourse(WidgetTester tester, String courseName) async {
      await tester.tap(find.byKey(EventDialogKeys.courseTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text(courseName));
      await tester.pumpAndSettle();
    }

    Future<void> selectDate(WidgetTester tester,
        {required String dayOfCurrentMonth}) async {
      await tester.tap(find.byKey(EventDialogKeys.startDateField));
      await tester.pumpAndSettle();
      await tester.tap(find.text(dayOfCurrentMonth));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    }

    Future<void> tapStartTimeField(WidgetTester tester) async {
      await tester.tap(find.byKey(EventDialogKeys.startTimeField));
      await tester.pumpAndSettle();
    }

    Future<void> tapEndTimeField(WidgetTester tester) async {
      await tester.tap(find.byKey(EventDialogKeys.endTimeField));
      await tester.pumpAndSettle();
    }

    Future<void> enterDescription(
        WidgetTester tester, String description) async {
      await tester.enterText(
          find.byKey(EventDialogKeys.descriptionTextField), description);
    }

    Future<void> enterLocation(WidgetTester tester, String location) async {
      await tester.enterText(
          find.byKey(EventDialogKeys.locationField), location);
    }

    Future<void> tapNotifyCourseMembersSwitch(WidgetTester tester) async {
      await tester.tap(find.byKey(EventDialogKeys.notifyCourseMembersSwitch));
      await tester.pumpAndSettle();
    }

    Future<void> tapSaveButton(WidgetTester tester) async {
      await tester.tap(find.byKey(EventDialogKeys.saveButton));
      await tester.pumpAndSettle();
    }

    /// Emulates going back via the native platform back button.
    ///
    /// For example for old Android phones this would be the back button at the
    /// bottom left of the phone (the triangle pointing to the left).
    Future<void> goBackViaPlatformButton(WidgetTester tester) async {
      // Copied from flutter code:
      // https://github.com/flutter/flutter/blob/bfeaf5a7f2c67d9efdde58874a452da46e722a45/packages/flutter/test/material/will_pop_test.dart#L139C1-L144C54
      // See also: https://stackoverflow.com/questions/65239597/flutter-testing-willpopscope-with-back-button
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
    }

    Future<void> goBackViaWidgetCloseButton(WidgetTester tester) async {
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle(const Duration(seconds: 1));
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
        addCourse(courseWith(id: 'fooId', name: 'Foo course'));

        await pumpAndSettleEventDialog(tester,
            isExam: testConfig.isExam, theme: testConfig.theme.data);

        await multiScreenGolden(
          tester,
          'event_dialog_add_empty_${testConfig.theme.name}_${testConfig.isExam ? 'exam' : 'event'}',
        );
      });
      testGoldens(
          'renders full event dialog as expected (${testConfig.theme.name}, isExam: ${testConfig.isExam})',
          (tester) async {
        addCourse(courseWith(id: 'fooId', name: 'Foo course'));

        await pumpAndSettleEventDialog(tester,
            isExam: testConfig.isExam, theme: testConfig.theme.data);

        await enterTitle(tester, 'Test title');
        await selectCourse(tester, 'Foo course');
        await withClock(
          Clock.fixed(
            DateTime(2022, 1, 1),
          ),
          () async {
            await selectDate(tester, dayOfCurrentMonth: '10');
          },
        );
        await enterDescription(tester, 'Test description');
        await enterLocation(tester, 'M12');
        await tapNotifyCourseMembersSwitch(tester);

        await multiScreenGolden(
          tester,
          'event_dialog_add_full_${testConfig.theme.name}_${testConfig.isExam ? 'exam' : 'event'}',
        );
      });
      testGoldens(
          'renders error event dialog as expected (${testConfig.theme.name}, isExam: ${testConfig.isExam})',
          (tester) async {
        late TimeOfDay timeOfDay;
        await pumpAndSettleEventDialog(
          tester,
          isExam: testConfig.isExam,
          theme: testConfig.theme.data,
          showTimeDialogTestOverride: () => timeOfDay,
        );

        // Set end time before start time to trigger the error message.
        timeOfDay = const TimeOfDay(hour: 12, minute: 0);
        await tapStartTimeField(tester);
        timeOfDay = const TimeOfDay(hour: 10, minute: 0);
        await tapEndTimeField(tester);

        // Triggers empty title and no course chosen error messages.
        await tapSaveButton(tester);

        await multiScreenGolden(
          tester,
          'event_dialog_add_error_${testConfig.theme.name}_${testConfig.isExam ? 'exam' : 'event'}',
        );
      });
    }
  });
}
