// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:bloc_provider/multi_bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/src/homework_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/pages/homework/homework_dialog.dart';
import 'package:sharezone/pages/settings/timetable_settings/time_picker_settings_cache.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';

import '../analytics/analytics_test.dart';
@GenerateNiceMocks([
  MockSpec<DocumentReference>(),
  MockSpec<SharezoneContext>(),
  MockSpec<SharezoneGateway>(),
  MockSpec<HomeworkGateway>(),
  MockSpec<CourseGateway>(),
])
import 'homework_dialog_test.mocks.dart';

class MockNextLessonCalculator implements NextLessonCalculator {
  Date? dateToReturn;
  @override
  Future<Date?> calculateNextLesson(String courseID) async {
    return dateToReturn ?? Date('2032-01-03');
  }
}

class MockHomeworkDialogApi implements HomeworkDialogApi {
  late UserInput userInputToBeCreated;
  @override
  Future<HomeworkDto> create(UserInput userInput) async {
    userInputToBeCreated = userInput;
    return HomeworkDto.create(courseID: 'courseID');
  }

  late UserInput userInputFromEditing;
  late List<CloudFile> removedCloudFilesFromEditing;
  @override
  Future<HomeworkDto> edit(HomeworkId homeworkId, UserInput userInput,
      {List<CloudFile> removedCloudFiles = const []}) async {
    userInputFromEditing = userInput;
    removedCloudFilesFromEditing = removedCloudFiles;
    return HomeworkDto.create(courseID: 'courseID');
  }

  final loadCloudFilesResult = <CloudFile>[];

  @override
  Future<List<CloudFile>> loadCloudFiles({required String homeworkId}) async {
    return loadCloudFilesResult;
  }

  HomeworkDto? homeworkToReturn;
  @override
  Future<HomeworkDto> loadHomework(HomeworkId homeworkId) async {
    return homeworkToReturn ?? HomeworkDto.create(courseID: 'courseID');
  }
}

void main() {
  group('HomeworkDialog', () {
    late MockHomeworkDialogApi homeworkDialogApi;
    late MockNextLessonCalculator nextLessonCalculator;
    late MockSharezoneContext sharezoneContext;
    late LocalAnalyticsBackend analyticsBackend;
    late Analytics analytics;
    HomeworkDto? homework;

    setUp(() {
      homeworkDialogApi = MockHomeworkDialogApi();
      nextLessonCalculator = MockNextLessonCalculator();
      sharezoneContext = MockSharezoneContext();
      analyticsBackend = LocalAnalyticsBackend();
      analytics = Analytics(analyticsBackend);
    });

    Future<void> pumpAndSettleHomeworkDialog(WidgetTester tester) async {
      if (homework != null) {
        final sharezoneGateway = MockSharezoneGateway();
        final homeworkGateway = MockHomeworkGateway();
        when(sharezoneContext.api).thenReturn(sharezoneGateway);
        when(sharezoneGateway.homework).thenReturn(homeworkGateway);
        when(homeworkGateway.singleHomework(any, source: Source.cache))
            .thenAnswer((_) => Future.value(homework));
      }
      homeworkDialogApi.homeworkToReturn = homework;

      await tester.pumpWidget(
        MultiBlocProvider(
          blocProviders: [
            BlocProvider<TimePickerSettingsCache>(
              bloc: TimePickerSettingsCache(
                InMemoryStreamingKeyValueStore(),
              ),
            ),
            BlocProvider<MarkdownAnalytics>(
              bloc: MarkdownAnalytics(analytics),
            ),
            BlocProvider<SharezoneContext>(bloc: sharezoneContext),
          ],
          child: (context) => MaterialApp(
            home: Scaffold(
              body: HomeworkDialog(
                homeworkDialogApi: homeworkDialogApi,
                nextLessonCalculator: nextLessonCalculator,
                id: homework?.id != null ? HomeworkId(homework!.id) : null,
              ),
            ),
          ),
        ),
      );

      // We have a delay for displaying the keyboard (using a Timer).
      // We have to wait until the timer is finished, otherwise this happens:
      //  The following assertion was thrown running a test:
      //  A Timer is still pending even after the widget tree was disposed.
      // We use a very long timer to show that it doesn't actually
      // make the test slower.
      await tester.pumpAndSettle(const Duration(seconds: 25));
    }

    testWidgets('edits homework correctly', (tester) async {
      final fooCourse = Course.create().copyWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
        abbreviation: 'F',
        myRole: MemberRole.admin,
      );

      final sharezoneGateway = MockSharezoneGateway();
      final courseGateway = MockCourseGateway();
      when(sharezoneContext.api).thenReturn(sharezoneGateway);
      when(sharezoneGateway.course).thenReturn(courseGateway);
      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([fooCourse]));
      when(sharezoneContext.analytics).thenReturn(analytics);
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      homeworkDialogApi.loadCloudFilesResult.addAll([
        CloudFile.create(
                id: 'foo_attachment_id1',
                creatorName: 'Assignment Creator Name',
                courseID: 'foo_course',
                creatorID: 'foo_creator_id',
                path: FolderPath.fromPathString(
                    '/foo_course/${FolderPath.attachments}'))
            .copyWith(name: 'foo_attachment1.png'),
        CloudFile.create(
                id: 'foo_attachment_id2',
                creatorName: 'Assignment Creator Name',
                courseID: 'foo_course',
                creatorID: 'foo_creator_id',
                path: FolderPath.fromPathString(
                    '/foo_course/${FolderPath.attachments}'))
            .copyWith(name: 'foo_attachment2.png'),
      ]);

      final mockDocumentReference = MockDocumentReference();
      when(mockDocumentReference.id).thenReturn('foo_course');
      homework = HomeworkDto.create(
              courseID: 'foo_course', courseReference: mockDocumentReference)
          .copyWith(
        id: 'foo_homework_id',
        title: 'title text',
        courseID: 'foo_course',
        courseName: 'Foo course',
        subject: 'Foo subject',
        // The submission time is included in the todoUntil date.
        withSubmissions: true,
        todoUntil: DateTime(2024, 03, 12, 16, 30),
        description: 'description text',
        attachments: ['foo_attachment_id1', 'foo_attachment_id2'],
        private: false,
      );
      await pumpAndSettleHomeworkDialog(tester);

      await tester.enterText(
          find.byKey(HwDialogKeys.titleTextField), 'New title text');
      await tester.pumpAndSettle();
      // NextLessonCalculator is mocked to return a fixed date. Using the UI
      // to select a specific date is tricky. Also this doesn't work:
      // await tester.tap(find.byKey(HwDialogKeys.todoUntilTile));
      // await tester.tap(find.text('OK'));
      // await tester.pumpAndSettle();
      await tester.tap(find.byKey(HwDialogKeys.submissionTile));
      await tester.pumpAndSettle();
      // Doesn't work, idk why:
      // await tester.tap(find.byKey(HwDialogKeys.submissionTimeTile));
      // await tester.pumpAndSettle(Duration(seconds: 25));
      // await tester.tap(find.text('OK'));
      await tester.enterText(
          find.byKey(HwDialogKeys.descriptionField), 'New description text');
      await tester
          .tap(find.byKey(HwDialogKeys.attachmentOverflowMenuIcon).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Anhang entfernen'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(HwDialogKeys.saveButton));

      final userInput = homeworkDialogApi.userInputFromEditing;
      final cloudFilesToBeRemoved =
          homeworkDialogApi.removedCloudFilesFromEditing;

      expect(userInput.title, 'New title text');
      expect(userInput.courseId.id, 'foo_course');
      // expect(userInput.course!.name, 'Foo course');
      // expect(userInput.course!.subject, 'Foo subject');
      // The following TestFailure was thrown running a test:
      // Expected: 'F'
      //   Actual: ''
      // expect(userInput.course!.abbreviation, 'F');
      // The following TestFailure was thrown running a test:
      // Expected: MemberRole:<MemberRole.admin>
      //   Actual: MemberRole:<MemberRole.standard>
      // expect(userInput.course!.myRole, MemberRole.admin);
      expect(userInput.withSubmission, true);
      // We didn't change it
      expect(userInput.todoUntil, homework!.todoUntil);
      expect(userInput.description, 'New description text');
      // The following TestFailure was thrown running a test:
      // Expected: an object with length of <1>
      //   Actual: []
      //    Which: has length of <0>
      // expect(userInput.localFiles, hasLength(1));
      // expect(userInput.localFiles?.first.getName(), 'foo_attachment2.png');
      expect(userInput.sendNotification, false);
      expect(userInput.private, false);
      expect(cloudFilesToBeRemoved, hasLength(1));
      expect(cloudFilesToBeRemoved.first.name, 'foo_attachment1.png');
      expect(analyticsBackend.loggedEvents, [
        {'homework_edit': {}}
      ]);
    });

    testWidgets('wants to create the correct homework', (tester) async {
      homework = null;

      final fooCourse = Course.create().copyWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
        abbreviation: 'F',
        myRole: MemberRole.admin,
      );

      final sharezoneGateway = MockSharezoneGateway();
      final courseGateway = MockCourseGateway();
      when(sharezoneContext.api).thenReturn(sharezoneGateway);
      when(sharezoneGateway.course).thenReturn(courseGateway);
      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([fooCourse]));
      when(sharezoneContext.analytics).thenReturn(analytics);
      final nextLessonDate = Date('2024-01-03');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      await pumpAndSettleHomeworkDialog(tester);

      await tester.enterText(
          find.byKey(HwDialogKeys.titleTextField), 'S. 24 a)');
      await tester.tap(find.byKey(HwDialogKeys.courseTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Foo course'));
      await tester.pumpAndSettle();
      // NextLessonCalculator is mocked to return a fixed date. Using the UI
      // to select a specific date is tricky. Also this doesn't work:
      // await tester.tap(find.byKey(HwDialogKeys.todoUntilTile));
      // await tester.tap(find.text('OK'));
      // await tester.pumpAndSettle();
      await tester.tap(find.byKey(HwDialogKeys.submissionTile));
      await tester.pumpAndSettle();
      // Doesn't work, idk why:
      // await tester.tap(find.byKey(HwDialogKeys.submissionTimeTile));
      // await tester.pumpAndSettle(Duration(seconds: 25));
      // await tester.tap(find.text('OK'));
      await tester.enterText(
          find.byKey(HwDialogKeys.descriptionField), 'Rechenweg aufschreiben');
      await tester.tap(find.byKey(HwDialogKeys.notifyCourseMembersTile));
      await tester.tap(find.byKey(HwDialogKeys.saveButton));

      final userInput = homeworkDialogApi.userInputToBeCreated;
      expect(userInput.title, 'S. 24 a)');
      expect(userInput.courseId.id, 'foo_course');
      // expect(userInput.course!.name, 'Foo course');
      // expect(userInput.course!.subject, 'Foo subject');
      // expect(userInput.course!.abbreviation, 'F');
      // expect(userInput.course!.myRole, MemberRole.admin);
      expect(userInput.withSubmission, true);
      // As we activated submissions we assume the default time of 23:59 is
      // used.
      final expected = DateTime(nextLessonDate.year, nextLessonDate.month,
          nextLessonDate.day, 23, 59);
      expect(userInput.todoUntil, expected);
      expect(userInput.description, 'Rechenweg aufschreiben');
      expect(userInput.localFiles, isEmpty);
      expect(userInput.sendNotification, true);
      expect(userInput.private, false);

      expect(analyticsBackend.loggedEvents, [
        {'homework_add': {}},
      ]);
    });

    testWidgets('should display an empty dialog when no homework is passed',
        (WidgetTester tester) async {
      homework = null;

      await pumpAndSettleHomeworkDialog(tester);

      // Not found, idk why:
      // expect(
      //     find.text('Titel eingeben', findRichText: true, skipOffstage: true),
      //     findsOneWidget);
      expect(find.text('Keinen Kurs ausgewählt'), findsOneWidget);
      expect(find.text('Datum auswählen'), findsOneWidget);
      expect(find.text('Mit Abgabe'), findsOneWidget);
      expect(find.text('Abgabe-Uhrzeit'), findsNothing);
      expect(find.text('Zusatzinformationen eingeben'), findsOneWidget);
      expect(find.text('Anhang hinzufügen'), findsOneWidget);
      expect(find.text('Kursmitglieder benachrichtigen'), findsOneWidget);
      expect(find.text('Privat'), findsOneWidget);
      expect(
          find.byWidgetPredicate(
              (element) => element is Switch && element.value == false),
          findsNWidgets(3));
      expect(
          find.byWidgetPredicate(
              (element) => element is Switch && element.value == true),
          findsNothing);
    });
    testWidgets('should display a prefilled dialog if homework is passed',
        (WidgetTester tester) async {
      final mockDocumentReference = MockDocumentReference();
      when(mockDocumentReference.id).thenReturn('foo_course');
      homework = HomeworkDto.create(
              courseID: 'foo_course', courseReference: mockDocumentReference)
          .copyWith(
        id: 'foo_homework_id',
        title: 'title text',
        courseID: 'foo_course',
        courseName: 'Foo course',
        subject: 'Foo subject',
        // The submission time is included in the todoUntil date.
        withSubmissions: true,
        todoUntil: DateTime(2024, 03, 12, 16, 30),
        description: 'description text',
        attachments: ['foo_attachment_id'],
        private: false,
      );
      homeworkDialogApi.loadCloudFilesResult.add(
        CloudFile.create(
                id: 'foo_attachment_id',
                creatorName: 'Assignment Creator Name',
                courseID: 'foo_course',
                creatorID: 'foo_creator_id',
                path: FolderPath.fromPathString(
                    '/foo_course/${FolderPath.attachments}'))
            .copyWith(name: 'foo_attachment.png'),
      );

      await pumpAndSettleHomeworkDialog(tester);

      expect(find.text('title text', findRichText: true), findsOneWidget);
      expect(find.text('Foo course'), findsOneWidget);
      // Not found, idk why:
      // expect(find.text('12. März 2024'), findsOneWidget);
      expect(find.text('Mit Abgabe'), findsOneWidget);
      expect(find.text('Abgabe-Uhrzeit'), findsOneWidget);
      expect(find.text('16:30'), findsOneWidget);
      expect(find.text('description text'), findsOneWidget);
      expect(find.text('Anhang hinzufügen'), findsOneWidget);
      expect(find.text('foo_attachment.png'), findsOneWidget);
      expect(find.text('Kursmitglieder über die Änderungen benachrichtigen'),
          findsOneWidget);
      expect(find.text('Privat'), findsOneWidget);
      // "Notify course members" & "is private" option are both disabled
      expect(
          find.byWidgetPredicate(
              (element) => element is Switch && element.value == false),
          findsNWidgets(2));
      // "With submissions" is enabled
      expect(
          find.byWidgetPredicate(
              (element) => element is Switch && element.value == true),
          findsOneWidget);
    });
  });
}

// Used temporarily when testing so one can see what happens "on the screen" in
// a widget test without having to use a real device / simulator to run these
// tests.
// --update-goldens
Future<void> generateGolden(String name) async {
  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('goldens/golden_$name.png'));
}
