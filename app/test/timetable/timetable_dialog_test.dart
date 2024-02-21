// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
import 'package:sharezone/timetable/timetable_add_event/src/timetable_add_event_dialog_src.dart';
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
      TimeOfDay Function()? showTimeDialogTestOverride,
    }) async {
      when(sharezoneGateway.course).thenReturn(courseGateway);
      when(sharezoneContext.api).thenReturn(sharezoneGateway);

      // Since the controller currently uses clock.now() when being created,
      // we need to move it here instead of `setUp` so that `withClock` works.
      controller = AddEventDialogController(api: api, isExam: isExam);

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

    Future<void> baseTest(WidgetTester tester, {required bool isExam}) async {
      await withClock(Clock.fixed(DateTime(2024, 3, 15)), () async {
        final course = courseWith(id: 'sportCourseId', name: 'Sport');
        addCourse(course);

        int counter = 0;
        await pumpDialog(
          tester,
          isExam: isExam,
          showTimeDialogTestOverride: () {
            counter++;
            if (counter == 1) {
              return const TimeOfDay(hour: 13, minute: 40);
            } else {
              return const TimeOfDay(hour: 15, minute: 50);
            }
          },
        );

        await enterTitle(tester, 'Sportfest');
        await selectCourse(tester, 'Sport');
        await selectDate(tester, dayOfCurrentMonth: '20');
        await tapStartTimeField(tester);
        await tapEndTimeField(tester);
        await enterDescription(tester,
            'Beim Sportfest treten wir in verschiedenen Disziplinen gegeneinander an.');
        await enterLocation(tester, 'Sportplatz');
        await tapNotifyCourseMembersSwitch(tester);

        await tapSaveButton(tester);
      });

      final command = verify(api.createEvent(captureAny)).captured.single
          as CreateEventCommand;

      expect(
        command,
        CreateEventCommand(
          title: 'Sportfest',
          courseId: CourseId('sportCourseId'),
          date: Date('2024-03-20'),
          startTime: Time(hour: 13, minute: 40),
          endTime: Time(hour: 15, minute: 50),
          description:
              'Beim Sportfest treten wir in verschiedenen Disziplinen gegeneinander an.',
          location: 'Sportplatz',
          notifyCourseMembers: false,
          eventType: isExam ? EventType.exam : EventType.event,
        ),
      );
    }

    testWidgets('saves event', (tester) async {
      await baseTest(tester, isExam: false);
    });

    testWidgets('saves exam', (tester) async {
      await baseTest(tester, isExam: true);
    });

    testWidgets(
        'changes both dates (start and end) on screen if the date is changed',
        (tester) async {
      await withClock(Clock.fixed(DateTime(2024, 3, 15)), () async {
        await pumpDialog(tester, isExam: false);

        await selectDate(tester, dayOfCurrentMonth: '27');
      });

      expect(find.textContaining('27'), findsNWidgets(2));
    });

    for (var goBack in [goBackViaWidgetCloseButton, goBackViaPlatformButton]) {
      testWidgets(
          'shows "are you sure" dialog if the user tries to close the dialog with unsaved changes (title)',
          (tester) async {
        await pumpDialog(tester, isExam: false);

        await enterTitle(tester, 'Test');

        await goBack(tester);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Eingabe verlassen?'), findsOneWidget);
      });

      testWidgets(
          'shows "are you sure" dialog if the user tries to close the dialog with unsaved changes (description/details)',
          (tester) async {
        await pumpDialog(tester, isExam: false);

        await enterDescription(tester, 'Test');
        await tester.pumpAndSettle();

        await goBack(tester);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Eingabe verlassen?'), findsOneWidget);
      });

      testWidgets(
          'doesnt show "are you sure" dialog if the user tries to close the dialog with no changes',
          (tester) async {
        await pumpDialog(tester, isExam: false);
        await goBack(tester);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Eingabe verlassen?'), findsNothing);
        expect(find.byType(TimetableAddEventDialog), findsNothing);
      });
    }

    testWidgets(
        'doesnt show title error message if save is not pressed and the title is empty',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      expect(find.text(EventDialogErrorStrings.emptyTitle), findsNothing);
    });
    testWidgets(
        'shows title error message if save is pressed and the title is empty',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      await tapSaveButton(tester);

      expect(find.text(EventDialogErrorStrings.emptyTitle), findsOneWidget);
    });
    testWidgets(
        'removes title error message if save is pressed with an empty title but text is entered afterwards',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      await tapSaveButton(tester);
      await enterTitle(tester, 'Foo');
      await tester.pumpAndSettle();

      expect(find.text(EventDialogErrorStrings.emptyTitle), findsNothing);
    });
    testWidgets(
        'shows course error message if save is pressed and no course is chosen',
        (tester) async {
      await pumpDialog(tester, isExam: false);

      await tapSaveButton(tester);

      expect(find.text(EventDialogErrorStrings.emptyCourse), findsOneWidget);
    });
    testWidgets('removes course error message if a course is chosen',
        (tester) async {
      final course = courseWith(id: 'fooId', name: 'Foo course');
      addCourse(course);
      await pumpDialog(tester, isExam: false);

      await tapSaveButton(tester);
      await selectCourse(tester, 'Foo course');

      expect(find.text(EventDialogErrorStrings.emptyCourse), findsNothing);
    });

    testWidgets('shows error message if end time is not after start time',
        (tester) async {
      late TimeOfDay timeOfDay;
      await pumpDialog(
        tester,
        isExam: false,
        showTimeDialogTestOverride: () => timeOfDay,
      );

      timeOfDay = const TimeOfDay(hour: 13, minute: 15);
      await tapStartTimeField(tester);
      timeOfDay = const TimeOfDay(hour: 13, minute: 15);
      await tapEndTimeField(tester);
      expect(find.text(EventDialogErrorStrings.endTimeMustBeAfterStartTime),
          findsOneWidget);

      timeOfDay = const TimeOfDay(hour: 12, minute: 00);
      await tapEndTimeField(tester);
      expect(find.text(EventDialogErrorStrings.endTimeMustBeAfterStartTime),
          findsOneWidget);
    });
    testWidgets('doesnt shows error message if end time after start time',
        (tester) async {
      late TimeOfDay timeOfDay;
      await pumpDialog(
        tester,
        isExam: false,
        showTimeDialogTestOverride: () => timeOfDay,
      );

      timeOfDay = const TimeOfDay(hour: 13, minute: 15);
      await tapStartTimeField(tester);
      timeOfDay = const TimeOfDay(hour: 15, minute: 30);
      await tapEndTimeField(tester);
      expect(find.text(EventDialogErrorStrings.endTimeMustBeAfterStartTime),
          findsNothing);
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
      await withClock(Clock.fixed(DateTime(2024, 2, 13)), () async {
        final course = courseWith(id: 'fooId', name: 'Foo course');
        addCourse(course);

        await pumpDialog(tester, isExam: false);
        await selectDate(tester, dayOfCurrentMonth: '16');
      });

      // I don't know why its the english date format in widget tests.
      // In German it would be "Fr., 16. Feb. 2024"
      expect(find.text('Fri, Feb 16, 2024'), findsNWidgets(2));
      expect(controller.date, Date('2024-02-16'));
    });

    testWidgets('selected start time is forwarded to controller',
        (tester) async {
      await withClock(
          Clock.fixed(
            DateTime(2024, 2, 13),
          ), () async {
        await pumpDialog(
          tester,
          isExam: false,
          // We can't select anything in the time picker, its like its not
          // visible to the widget tests. So we have to return a fake time and
          // not use the real time picker at all.
          showTimeDialogTestOverride: () =>
              const TimeOfDay(hour: 11, minute: 30),
        );

        await tapStartTimeField(tester);
      });

      expect(find.text('11:30'), findsOneWidget);
      expect(controller.startTime, Time(hour: 11, minute: 30));
    });
    testWidgets('selected end time is forwarded to controller', (tester) async {
      await withClock(Clock.fixed(DateTime(2024, 2, 13)), () async {
        await pumpDialog(
          tester,
          isExam: false,
          showTimeDialogTestOverride: () =>
              const TimeOfDay(hour: 12, minute: 30),
        );

        await tapEndTimeField(tester);
      });

      expect(find.text('12:30'), findsOneWidget);
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
