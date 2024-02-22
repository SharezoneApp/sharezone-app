// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/timetable/timetable_add_event/src/timetable_add_event_dialog_src.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';
import 'package:time/time.dart';

import '../homework/homework_dialog_test.dart';
import '../homework/homework_dialog_test.mocks.dart';
@GenerateNiceMocks([
  MockSpec<EventDialogApi>(),
])
import 'timetable_dialog_test.mocks.dart';
import 'timetable_dialog_tester.dart';

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

    Future<void> baseTest(WidgetTester tester, {required bool isExam}) async {
      final dt = createDialogTester(tester);
      await withClock(Clock.fixed(DateTime(2024, 3, 15)), () async {
        final course = courseWith(id: 'sportCourseId', name: 'Sport');
        dt.addCourse(course);

        await dt.pumpDialog(isExam: isExam);

        await dt.enterTitle('Sportfest');
        await dt.selectCourse('Sport');
        await dt.selectDate(dayOfCurrentMonth: '20');
        await dt.selectStartTime(const TimeOfDay(hour: 13, minute: 40));
        await dt.selectEndTime(const TimeOfDay(hour: 15, minute: 50));
        await dt.enterDescription(
            'Beim Sportfest treten wir in verschiedenen Disziplinen gegeneinander an.');
        await dt.enterLocation('Sportplatz');
        await dt.tapNotifyCourseMembersSwitch();

        await dt.tapSaveButton();
      });

      final command = verify(dt.api.createEvent(captureAny)).captured.single
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
        final dt = createDialogTester(tester);
        await dt.pumpDialog(isExam: false);

        await dt.selectDate(dayOfCurrentMonth: '27');
      });

      expect(find.textContaining('27'), findsNWidgets(2));
    });

    for (var goBack in [
      (TimetableDialogTester dt) => dt.goBackViaWidgetCloseButton(),
      (TimetableDialogTester dt) => dt.goBackViaPlatformButton()
    ]) {
      testWidgets(
          'shows "are you sure" dialog if the user tries to close the dialog with unsaved changes (title)',
          (tester) async {
        final dt = createDialogTester(tester);
        await dt.pumpDialog(isExam: false);

        await dt.enterTitle('Test');

        await goBack(dt);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Eingabe verlassen?'), findsOneWidget);
      });

      testWidgets(
          'shows "are you sure" dialog if the user tries to close the dialog with unsaved changes (description/details)',
          (tester) async {
        final dt = createDialogTester(tester);
        await dt.pumpDialog(isExam: false);

        await dt.enterDescription('Test');
        await tester.pumpAndSettle();

        await goBack(dt);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Eingabe verlassen?'), findsOneWidget);
      });

      testWidgets(
          'doesnt show "are you sure" dialog if the user tries to close the dialog with no changes',
          (tester) async {
        final dt = createDialogTester(tester);
        await dt.pumpDialog(isExam: false);
        await goBack(dt);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Eingabe verlassen?'), findsNothing);
        expect(find.byType(TimetableAddEventDialog), findsNothing);
      });
    }

    testWidgets(
        'doesnt show title error message if save is not pressed and the title is empty',
        (tester) async {
      final dt = createDialogTester(tester);

      await dt.pumpDialog(isExam: false);

      expect(find.text(EventDialogErrorStrings.emptyTitle), findsNothing);
    });
    testWidgets(
        'shows title error message if save is pressed and the title is empty',
        (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.tapSaveButton();

      expect(find.text(EventDialogErrorStrings.emptyTitle), findsOneWidget);
    });
    testWidgets(
        'removes title error message if save is pressed with an empty title but text is entered afterwards',
        (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.tapSaveButton();
      await dt.enterTitle('Foo');
      await tester.pumpAndSettle();

      expect(find.text(EventDialogErrorStrings.emptyTitle), findsNothing);
    });
    testWidgets(
        'shows course error message if save is pressed and no course is chosen',
        (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.tapSaveButton();

      expect(find.text(EventDialogErrorStrings.emptyCourse), findsOneWidget);
    });
    testWidgets('removes course error message if a course is chosen',
        (tester) async {
      final dt = createDialogTester(tester);
      final course = courseWith(id: 'fooId', name: 'Foo course');
      dt.addCourse(course);
      await dt.pumpDialog(isExam: false);

      await dt.tapSaveButton();
      await dt.selectCourse('Foo course');

      expect(find.text(EventDialogErrorStrings.emptyCourse), findsNothing);
    });

    testWidgets('shows error message if end time is not after start time',
        (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.selectStartTime(const TimeOfDay(hour: 13, minute: 15));
      await dt.selectEndTime(const TimeOfDay(hour: 13, minute: 15));
      expect(find.text(EventDialogErrorStrings.endTimeMustBeAfterStartTime),
          findsOneWidget);

      await dt.selectEndTime(const TimeOfDay(hour: 12, minute: 00));
      expect(find.text(EventDialogErrorStrings.endTimeMustBeAfterStartTime),
          findsOneWidget);
    });
    testWidgets('doesnt shows error message if end time after start time',
        (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.selectStartTime(const TimeOfDay(hour: 13, minute: 15));
      await dt.selectEndTime(const TimeOfDay(hour: 15, minute: 30));
      expect(find.text(EventDialogErrorStrings.endTimeMustBeAfterStartTime),
          findsNothing);
    });

    testWidgets('shows empty event state if `isExam` is false', (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      expect(find.textContaining('Termin'), findsWidgets);
      expect(find.textContaining('Klausur'), findsNothing);
    });

    testWidgets('shows empty exam state if `isExam` is true', (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: true);

      expect(find.textContaining('Klausur'), findsWidgets);
      expect(find.textContaining('Termin'), findsNothing);
    });

    testWidgets('entered title is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.enterTitle('Test');

      expect(find.text('Test'), findsOneWidget);
      expect(dt.dialogController.title, 'Test');
    });

    testWidgets('selected course is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      final course = courseWith(id: 'fooId', name: 'Foo course');
      dt.addCourse(course);

      await dt.pumpDialog(isExam: false);
      await dt.selectCourse('Foo course');

      expect(find.text('Foo course'), findsOneWidget);
      expect(dt.dialogController.course?.id, CourseId('fooId'));
    });

    testWidgets('selected date is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await withClock(Clock.fixed(DateTime(2024, 2, 13)), () async {
        final course = courseWith(id: 'fooId', name: 'Foo course');
        dt.addCourse(course);

        await dt.pumpDialog(isExam: false);
        await dt.selectDate(dayOfCurrentMonth: '16');
      });

      // I don't know why its the english date format in widget tests.
      // In German it would be "Fr., 16. Feb. 2024"
      expect(find.text('Fri, Feb 16, 2024'), findsNWidgets(2));
      expect(dt.dialogController.date, Date('2024-02-16'));
    });

    testWidgets('selected start time is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await withClock(
          Clock.fixed(
            DateTime(2024, 2, 13),
          ), () async {
        await dt.pumpDialog(isExam: false);

        await dt.selectStartTime(const TimeOfDay(hour: 11, minute: 30));
      });

      expect(find.text('11:30'), findsOneWidget);
      expect(dt.dialogController.startTime, Time(hour: 11, minute: 30));
    });
    testWidgets('selected end time is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await withClock(Clock.fixed(DateTime(2024, 2, 13)), () async {
        await dt.pumpDialog(isExam: false);

        await dt.selectEndTime(const TimeOfDay(hour: 12, minute: 30));
      });

      expect(find.text('12:30'), findsOneWidget);
      expect(dt.dialogController.endTime, Time(hour: 12, minute: 30));
    });

    testWidgets('entered description is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.enterDescription('Test description');

      expect(find.text('Test description'), findsOneWidget);
      expect(dt.dialogController.description, 'Test description');
    });

    testWidgets('entered location/room is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.enterLocation('Raum M12');

      expect(find.text('Raum M12'), findsOneWidget);
      expect(dt.dialogController.location, 'Raum M12');
    });

    testWidgets('notify course members is forwarded to dt', (tester) async {
      final dt = createDialogTester(tester);
      await dt.pumpDialog(isExam: false);

      await dt.tapNotifyCourseMembersSwitch();

      expect(
          find.byWidgetPredicate(
              (widget) => widget is Switch && widget.value == false),
          findsOneWidget);
      expect(dt.dialogController.notifyCourseMembers, false);
    });
  });
}
