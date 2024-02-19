import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';
import 'package:time/time.dart';

import '../homework/homework_dialog_test.dart';
import '../homework/homework_dialog_test.mocks.dart';
@GenerateNiceMocks([
  MockSpec<EventDialogApi>(),
])
import 'timetable_dialog_test.mocks.dart';

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

    Future<void> pumpDialog(
      WidgetTester tester, {
      required bool isExam,
      Clock? clockOverride,
      required,
      TimeOfDay Function()? showTimeDialogTestOverride,
    }) async {
      when(sharezoneGateway.course).thenReturn(courseGateway);
      when(sharezoneContext.api).thenReturn(sharezoneGateway);

      await withClock(clockOverride ?? clock, () async {
        // Since the controller currently calls clock.now() when being created,
        // we need to move it here instead of `setUp` so that `withClock` works.
        controller = AddEventDialogController(api: api);

        await tester.pumpWidget(
          MultiBlocProvider(
            blocProviders: [
              BlocProvider<SharezoneContext>(
                bloc: sharezoneContext,
              )
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
      });
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
      await tester.tap(find.text('Foo course'));
      await tester.pumpAndSettle();
    }

    Future<void> selectDate(WidgetTester tester,
        {required String dayOfCurrentMonth}) async {
      await tester.tap(find.byKey(EventDialogKeys.startDateField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('16'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
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

    testWidgets('saves basic event', (tester) async {
      final course = courseWith(id: 'fooId', name: 'Foo course');
      addCourse(course);

      await pumpDialog(tester,
          isExam: false, clockOverride: Clock.fixed(DateTime(2024, 3, 15)));

      await enterTitle(tester, 'Test');
      await selectCourse(tester, 'Foo course');
      await tapSaveButton(tester);

      final command = verify(api.createEvent(captureAny)).captured.single
          as CreateEventCommand;
      expect(command.title, 'Test');
      expect(command.courseId, CourseId('fooId'));
      expect(command.date, Date('2024-03-15'));
    });

    testWidgets('shows empty event state if `isExam` is false', (tester) async {
      await pumpDialog(tester, isExam: false);

      expect(find.textContaining('Termin'), findsWidgets);
      expect(find.textContaining('Klausur'), findsNothing);
    });
    testWidgets('shows empty exam state if `isExam` is true', (tester) async {
      await pumpDialog(tester, isExam: true);

      expect(find.textContaining('Klausur'), findsWidgets);
      expect(find.textContaining('Termin'), findsNothing);
    });

    testWidgets('entered title is forwarded to controller', (tester) async {
      await pumpDialog(tester, isExam: false);

      await enterTitle(tester, 'Test');

      expect(find.text('Test'), findsOneWidget);
      expect(controller.title, 'Test');
    });

    testWidgets('selected course is forwarded to controller', (tester) async {
      final course = courseWith(id: 'fooId', name: 'Foo course');
      addCourse(course);

      await pumpDialog(tester, isExam: false);
      await selectCourse(tester, 'Foo course');

      expect(find.text('Foo course'), findsOneWidget);
      expect(controller.course?.id, CourseId('fooId'));
    });

    testWidgets('selected date is forwarded to controller', (tester) async {
      final course = courseWith(id: 'fooId', name: 'Foo course');
      addCourse(course);

      await pumpDialog(tester,
          isExam: false, clockOverride: Clock.fixed(DateTime(2024, 2, 13)));
      await selectDate(tester, dayOfCurrentMonth: '16');

      // I don't know why its the english date format in widget tests.
      // In German it would be "Fr., 16. Feb. 2024"
      expect(find.text('Fri, Feb 16, 2024'), findsOneWidget);
      expect(controller.date, Date('2024-02-16'));
    });

    testWidgets('selected start time is forwarded to controller',
        (tester) async {
      await pumpDialog(
        tester,
        isExam: false,
        clockOverride: Clock.fixed(
          DateTime(2024, 2, 13),
        ),
        showTimeDialogTestOverride: () => const TimeOfDay(hour: 11, minute: 30),
      );

      await tester.tap(find.byKey(EventDialogKeys.startTimeField));
      // await tester.pumpAndSettle(const Duration(seconds: 1));
      // await tester.tap(find.text('11'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('30'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('OK'));
      // await tester.pumpAndSettle();

      // I don't know why its the english date format in widget tests.
      // In German it would be "Fr., 16. Feb. 2024"
      // expect(find.text('11:30'), findsOneWidget);
      expect(controller.startTime, Time(hour: 11, minute: 30));
    });
    testWidgets('selected end time is forwarded to controller', (tester) async {
      await pumpDialog(
        tester,
        isExam: false,
        clockOverride: Clock.fixed(
          DateTime(2024, 2, 13),
        ),
        showTimeDialogTestOverride: () => const TimeOfDay(hour: 12, minute: 30),
      );

      await tester.tap(find.byKey(EventDialogKeys.endTimeField));
      // await tester.pumpAndSettle(const Duration(seconds: 1));
      // await tester.tap(find.text('11'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('30'));
      // await tester.pumpAndSettle();
      // await tester.tap(find.text('OK'));
      // await tester.pumpAndSettle();

      // I don't know why its the english date format in widget tests.
      // In German it would be "Fr., 16. Feb. 2024"
      // expect(find.text('11:30'), findsOneWidget);
      expect(controller.endTime, Time(hour: 12, minute: 30));
    });

    testWidgets('entered description is forwarded to controller',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      await enterDescription(tester, 'Test description');

      expect(find.text('Test description'), findsOneWidget);
      expect(controller.description, 'Test description');
    });

    testWidgets('entered location/room is forwarded to controller',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      await enterLocation(tester, 'Raum M12');

      expect(find.text('Raum M12'), findsOneWidget);
      expect(controller.location, 'Raum M12');
    });

    testWidgets('notify course members is forwarded to controller',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      await tapNotifyCourseMembersSwitch(tester);

      expect(
          find.byWidgetPredicate(
              (widget) => widget is Switch && widget.value == false),
          findsOneWidget);
      expect(controller.notifyCourseMembers, false);
    });
  });
}
