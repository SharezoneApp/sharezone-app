// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/timetable/timetable_add_event/src/timetable_add_event_dialog_src.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';

import '../homework/homework_dialog_test.mocks.dart';
import 'timetable_dialog_test.mocks.dart';

class TimetableDialogTester {
  late AddEventDialogController dialogController;
  late final MockEventDialogApi api;
  late final SharezoneContext sharezoneContext;
  late final MockCourseGateway courseGateway;
  late final MockSharezoneGateway sharezoneGateway;
  final WidgetTester tester;

  // We can't select anything in the time picker, its like its not
  // visible to the widget tests. So we have to return a fake time
  // and not use/show the real time picker at all in our widget tests.
  TimeOfDay? _overriddenTime;
  TimeOfDay _showTimePickerDialogTestOverride() {
    return _overriddenTime!;
  }

  TimetableDialogTester({
    required this.api,
    required this.sharezoneContext,
    required this.courseGateway,
    required this.sharezoneGateway,
    required this.tester,
  }) {
    when(sharezoneGateway.course).thenReturn(courseGateway);
    when(sharezoneContext.api).thenReturn(sharezoneGateway);
  }

  Future<void> pumpDialog({
    required bool isExam,
    ThemeData? theme,
    FocusNode? titleFocusNode,

    /// The duration of `pumpAndSettle` after the dialog has been built.
    ///
    /// We use this because in the dialog we delay focusing the title field
    /// by awaiting a delayed future. This will create a Timer which will cause
    /// some widget tests to fail because of this:
    /// ```
    /// The following assertion was thrown running a test:
    /// A Timer is still pending even after the widget tree was disposed.
    /// ```
    ///
    /// Since we don't want to add a additional call to pumpAndSettle to every
    /// test that uses this method, we add this parameter.
    Duration? additionalPumpAndSettleDuration = const Duration(seconds: 1),
  }) async {
    dialogController = AddEventDialogController(
      api: api,
      isExam: isExam,
      markdownAnalytics: MarkdownAnalytics(Analytics(NullAnalyticsBackend())),
    );

    await tester.pumpWidgetBuilder(
      MultiBlocProvider(
        blocProviders: [
          BlocProvider<SharezoneContext>(
            bloc: sharezoneContext,
          ),
        ],
        child: (context) => TimetableAddEventDialog(
          isExam: isExam,
          controller: dialogController,
          // We can't select anything in the time picker, its like its not
          // visible to the widget tests. So we have to return a fake time
          // and not use the real time picker at all.
          showTimePickerTestOverride: _showTimePickerDialogTestOverride,
          titleFocusNode: titleFocusNode,
        ),
      ),
      wrapper: materialAppWrapper(theme: theme),
    );

    await tester.pumpAndSettle(
        additionalPumpAndSettleDuration ?? const Duration(milliseconds: 100));
  }

  void addCourse(Course course) {
    when(courseGateway.streamCourses())
        .thenAnswer((_) => Stream.value([course]));
    when(api.loadCourse(any)).thenAnswer((_) => Future.value(course));
  }

  Future<void> enterTitle(String title) async {
    await tester.enterText(find.byKey(EventDialogKeys.titleTextField), title);
  }

  Future<void> selectCourse(String courseName) async {
    await tester.tap(find.byKey(EventDialogKeys.courseTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text(courseName));
    await tester.pumpAndSettle();
  }

  Future<void> selectDate({required String dayOfCurrentMonth}) async {
    await tester.tap(find.byKey(EventDialogKeys.startDateField));
    await tester.pumpAndSettle();
    await tester.tap(find.text(dayOfCurrentMonth));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Future<void> tapOnEndDateField() async {
    await tester.tap(find.byKey(EventDialogKeys.endDateField));
    await tester.pumpAndSettle();
  }

  Future<void> selectStartTime(TimeOfDay time) async {
    _overriddenTime = time;
    // We just have to tap the field, the timer picker dialog will not show as
    // we use our overridden method that just returns our overridden time.
    // This is because the time picker dialog is not visible to the widget tests
    // and we can't select anything in it.
    await tester.tap(find.byKey(EventDialogKeys.startTimeField));
    await tester.pumpAndSettle();
  }

  Future<void> selectEndTime(TimeOfDay time) async {
    _overriddenTime = time;
    // We just have to tap the field, the timer picker dialog will not show as
    // we use our overridden method that just returns our overridden time.
    // This is because the time picker dialog is not visible to the widget tests
    // and we can't select anything in it.
    await tester.tap(find.byKey(EventDialogKeys.endTimeField));
    await tester.pumpAndSettle();
  }

  Future<void> enterDescription(String description) async {
    await tester.enterText(
        find.byKey(EventDialogKeys.descriptionTextField), description);
  }

  Future<void> enterLocation(String location) async {
    await tester.enterText(find.byKey(EventDialogKeys.locationField), location);
  }

  Future<void> tapNotifyCourseMembersSwitch() async {
    await tester.tap(find.byKey(EventDialogKeys.notifyCourseMembersSwitch));
    await tester.pumpAndSettle();
  }

  Future<void> tapSaveButton() async {
    await tester.tap(find.byKey(EventDialogKeys.saveButton));
    await tester.pumpAndSettle();
  }

  /// Emulates going back via the native platform back button.
  ///
  /// For example for old Android phones this would be the back button at the
  /// bottom left of the phone (the triangle pointing to the left).
  Future<void> goBackViaPlatformButton() async {
    // Copied from flutter code:
    // https://github.com/flutter/flutter/blob/bfeaf5a7f2c67d9efdde58874a452da46e722a45/packages/flutter/test/material/will_pop_test.dart#L139C1-L144C54
    // See also: https://stackoverflow.com/questions/65239597/flutter-testing-willpopscope-with-back-button
    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();
  }

  Future<void> goBackViaWidgetCloseButton() async {
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }
}
