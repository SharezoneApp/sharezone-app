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

class TimetableDialogTestController {
  late AddEventDialogController controller;
  late final MockEventDialogApi api;
  late final SharezoneContext sharezoneContext;
  late final MockCourseGateway courseGateway;
  late final MockSharezoneGateway sharezoneGateway;
  final WidgetTester tester;

  TimetableDialogTestController({
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
    TimeOfDay Function()? showTimeDialogTestOverride,
  }) async {
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

  Future<void> pumpAndSettleForGolden(
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

    await tester.pumpWidgetBuilder(
      MultiBlocProvider(
        blocProviders: [
          BlocProvider<SharezoneContext>(
            bloc: sharezoneContext,
          ),
        ],
        child: (context) => Scaffold(
          body: TimetableAddEventDialog(
            isExam: isExam,
            controller: controller,
            showTimePickerTestOverride: showTimeDialogTestOverride,
          ),
        ),
      ),
      wrapper: materialAppWrapper(theme: theme),
    );
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

  Future<void> tapStartTimeField() async {
    await tester.tap(find.byKey(EventDialogKeys.startTimeField));
    await tester.pumpAndSettle();
  }

  Future<void> tapEndTimeField() async {
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
