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
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/src/homework_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:random_string/random_string.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog_bloc.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/settings/src/subpages/timetable/time_picker_settings_cache.dart';
import 'package:sharezone/util/api.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../analytics/analytics_test.dart';
import 'homework_dialog_bloc_test.dart';
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
  List<Date>? datesToReturn;
  final datesForCourses = <String, List<Date>>{};

  void returnLessonsForCourse(String courseID, List<Date> dates) {
    datesForCourses[courseID] = dates;
  }

  @override
  Future<Date?> tryCalculateNextLesson(String courseID) async {
    return dateToReturn ??
        datesToReturn?.first ??
        datesForCourses[courseID]?.first;
  }

  @override
  Future<Date?> tryCalculateXNextLesson(String courseID,
      {int inLessons = 1}) async {
    if (datesForCourses.isNotEmpty) {
      return datesForCourses[courseID]?.elementAt(inLessons - 1);
    }
    return datesToReturn?.elementAt(inLessons - 1) ?? dateToReturn;
  }
}

class MockHomeworkDialogApi implements HomeworkDialogApi {
  late UserInput userInputToBeCreated;
  late CourseId courseIdForHomeworkToBeCreated;
  Exception? createHomeworkError;

  @override
  Future<HomeworkDto> createHomework(
      CourseId courseId, UserInput userInput) async {
    if (createHomeworkError != null) {
      throw createHomeworkError!;
    }
    courseIdForHomeworkToBeCreated = courseId;
    userInputToBeCreated = userInput;
    return HomeworkDto.create(courseID: 'courseID');
  }

  late UserInput userInputFromEditing;
  late List<CloudFile> removedCloudFilesFromEditing;
  Exception? editHomeworkError;

  @override
  Future<HomeworkDto> editHomework(HomeworkId homeworkId, UserInput userInput,
      {List<CloudFile> removedCloudFiles = const []}) async {
    if (editHomeworkError != null) {
      throw editHomeworkError!;
    }
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

  void addCourseForTesting(Course course) {
    courses[CourseId(course.id)] = course;
  }

  final courses = <CourseId, Course>{};

  @override
  Future<Course> loadCourse(CourseId courseId) async {
    return courses[courseId] ?? Course.create();
  }
}

Course courseWith({required String id, String? name, String? subject}) {
  return Course.create().copyWith(
    id: id,
    name: name ?? subject ?? 'Foo course',
    subject: subject ?? (name != null ? '$name subject' : name),
    abbreviation: name?.substring(0, 1) ?? subject?.substring(0, 1) ?? 'F',
    myRole: MemberRole.admin,
  );
}

LocalFile randomLocalFileFrom({String path = 'foo/bar.png'}) {
  final b = basename(path);
  return FakeLocalFile(
    fileName: b,
    sizeBytes: b.length,
    path: path,
    fileData: Uint8List.fromList(b.codeUnits),
    mimeType: MimeType.fromFileNameOrNull(b),
  );
}

bool randomBool() {
  return randomBetween(0, 2).isEven;
}

HomeworkDto randomHomeworkWith({
  String? id,
  String? courseId,
  String? courseName,
  String? subject,
  String? title,
  String? description,
  DateTime? todoUntil,
  bool? withSubmissions,
  bool? private,
  bool? sendNotification,
  List<String>? attachments,
}) {
  id = id ?? 'random_id_${randomAlphaNumeric(10)}';
  courseId = courseId ?? 'random_course_id_${randomAlphaNumeric(5)}';
  courseName = courseName ?? 'Random Course Name ${randomAlphaNumeric(5)}';
  subject = subject ?? 'Random Subject ${randomAlphaNumeric(5)}';
  title = title ?? 'Random Title ${randomAlphaNumeric(5)}';
  description = description ?? 'Random Description ${randomAlphaNumeric(5)}';
  withSubmissions = withSubmissions ?? randomBool();
  todoUntil = todoUntil ??
      (withSubmissions
          ? DateTime(2023, 03, 12, 16, 30)
          : DateTime(2023, 03, 12));
  private = private ?? !withSubmissions;
  sendNotification = sendNotification ?? randomBool();

  final mockDocumentReference = MockDocumentReference();
  when(mockDocumentReference.id).thenReturn(courseId);
  return HomeworkDto.create(
          courseID: courseId, courseReference: mockDocumentReference)
      .copyWith(
    id: id,
    title: title,
    courseID: courseId,
    courseName: courseName,
    subject: subject,
    withSubmissions: withSubmissions,
    todoUntil: todoUntil,
    description: description,
    attachments: attachments ?? [],
    private: private,
    sendNotification: sendNotification,
  );
}

CloudFile randomAttachmentCloudFileWith(
    {String? id, String? name, String? courseId}) {
  name = name ?? 'random_file_name_${randomAlphaNumeric(5)}.png';
  courseId = courseId ?? 'random_course_id_${randomAlphaNumeric(5)}';
  final fileType = fileFormatEnumFromFilenameWithExtension(name);
  return CloudFile.create(
          id: id ?? 'random_id_${randomAlphaNumeric(10)}',
          creatorName:
              'Random Assignment Creator Name ${randomAlphaNumeric(5)}',
          courseID: courseId,
          creatorID: 'random_file_creator_id_${randomAlphaNumeric(5)}',
          isPrivate: randomBool(),
          path:
              FolderPath.fromPathString('/$courseId/${FolderPath.attachments}'))
      .copyWith(name: name, fileFormat: fileType);
}

void main() {
  group('HomeworkDialog', () {
    late MockHomeworkDialogApi homeworkDialogApi;
    late MockNextLessonCalculator nextLessonCalculator;
    late MockSharezoneContext sharezoneContext;
    late LocalAnalyticsBackend analyticsBackend;
    late Analytics analytics;
    late MockSharezoneGateway sharezoneGateway;
    late MockCourseGateway courseGateway;
    late MockHomeworkGateway homeworkGateway;
    Clock? clockOverride;

    HomeworkDto? homework;

    setUp(() {
      sharezoneGateway = MockSharezoneGateway();
      courseGateway = MockCourseGateway();
      homeworkGateway = MockHomeworkGateway();
      homeworkDialogApi = MockHomeworkDialogApi();
      nextLessonCalculator = MockNextLessonCalculator();
      sharezoneContext = MockSharezoneContext();
      analyticsBackend = LocalAnalyticsBackend();
      analytics = Analytics(analyticsBackend);
      homework = null;
      clockOverride = null;
    });

    Future<void> pumpAndSettleHomeworkDialog(WidgetTester tester,
        {bool showDueDateSelectionChips = false}) async {
      when(sharezoneGateway.course).thenReturn(courseGateway);
      when(sharezoneContext.api).thenReturn(sharezoneGateway);
      when(sharezoneContext.analytics).thenReturn(analytics);
      if (homework != null) {
        when(sharezoneGateway.homework).thenReturn(homeworkGateway);
        when(homeworkGateway.singleHomework(any, source: Source.cache))
            .thenAnswer((_) => Future.value(homework));
      }
      homeworkDialogApi.homeworkToReturn = homework;

      await withClock(clockOverride ?? clock, () async {
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
                  showDueDateSelectionChips: showDueDateSelectionChips,
                ),
              ),
            ),
          ),
        );
      });

      // We have a delay for displaying the keyboard (using a Timer).
      // We have to wait until the timer is finished, otherwise this happens:
      //  The following assertion was thrown running a test:
      //  A Timer is still pending even after the widget tree was disposed.
      // We use a very long timer to show that it doesn't actually
      // make the test slower.
      await tester.pumpAndSettle(const Duration(seconds: 25));
    }

    void addCourse(Course course) {
      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([course]));
      homeworkDialogApi.addCourseForTesting(course);
    }

    testWidgets('edits homework correctly', (tester) async {
      final fooCourse = courseWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
      );

      addCourse(fooCourse);
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      final attachment1 = randomAttachmentCloudFileWith(
        id: 'foo_attachment_id1',
        courseId: 'foo_course',
        name: 'foo_attachment1.png',
      );
      final attachment2 = randomAttachmentCloudFileWith(
        id: 'foo_attachment_id2',
        courseId: 'foo_course',
        name: 'foo_attachment2.pdf',
      );
      homeworkDialogApi.loadCloudFilesResult.addAll([
        attachment1,
        attachment2,
      ]);

      homework = randomHomeworkWith(
        id: 'foo_homework_id',
        title: 'title text',
        courseId: 'foo_course',
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
      final firstAttachment =
          find.byKey(HwDialogKeys.attachmentOverflowMenuIcon).first;
      await tester.ensureVisible(firstAttachment);
      await tester.tap(firstAttachment);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Anhang entfernen'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(HwDialogKeys.saveButton));

      final userInput = homeworkDialogApi.userInputFromEditing;
      final cloudFilesToBeRemoved =
          homeworkDialogApi.removedCloudFilesFromEditing;

      expect(userInput.title, 'New title text');
      expect(userInput.withSubmission, true);
      // We didn't change it
      expect(userInput.todoUntil, homework!.todoUntil);
      expect(userInput.description, 'New description text');
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

      final fooCourse = courseWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
      );

      addCourse(fooCourse);

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
      await tester.ensureVisible(find
          .byKey(HwDialogKeys.notifyCourseMembersTile, skipOffstage: false));
      await tester.tap(find.byKey(HwDialogKeys.notifyCourseMembersTile));
      await tester.tap(find.byKey(HwDialogKeys.saveButton));

      final userInput = homeworkDialogApi.userInputToBeCreated;
      final courseId = homeworkDialogApi.courseIdForHomeworkToBeCreated;
      expect(userInput.title, 'S. 24 a)');
      expect(courseId, CourseId('foo_course'));
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
      final fooCourse = courseWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
      );

      final mockDocumentReference = MockDocumentReference();
      when(mockDocumentReference.id).thenReturn('foo_course');
      addCourse(fooCourse);
      homework = randomHomeworkWith(
        id: 'foo_homework_id',
        title: 'title text',
        courseId: 'foo_course',
        courseName: 'Foo course',
        subject: 'Foo subject',
        // The submission time is included in the todoUntil date.
        withSubmissions: true,
        todoUntil: DateTime(2024, 03, 12, 16, 30),
        description: 'description text',
        attachments: ['foo_attachment_id'],
        private: false,
      );

      homeworkDialogApi.loadCloudFilesResult.add(randomAttachmentCloudFileWith(
        name: 'foo_attachment.png',
        courseId: 'foo_course',
      ));

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

    testWidgets(
        'homework lesson chips are visible if the function is activated',
        (tester) async {
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      expect(find.text('Nächster Schultag'), findsOneWidget);
      expect(find.text('Nächste Stunde'), findsOneWidget);
      expect(find.text('Übernächste Stunde'), findsOneWidget);
      expect(find.text('Benutzerdefiniert'), findsOneWidget);
    });

    testWidgets(
        'homework lesson chips are not visible if the function is deactivated',
        (tester) async {
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: false);

      expect(find.text('Nächster Schultag'), findsNothing);
      expect(find.text('Nächste Stunde'), findsNothing);
      expect(find.text('Übernächste Stunde'), findsNothing);
      expect(find.text('Benutzerdefiniert'), findsNothing);
    });

    testWidgets('homework lesson chips are not visible in edit mode',
        (tester) async {
      addCourse(courseWith(
        id: 'foo_course',
        name: 'Foo course',
      ));

      homework = randomHomeworkWith(
        id: 'foo_homework_id',
        title: 'title text',
        courseId: 'foo_course',
        courseName: 'Foo course',
        subject: 'Foo subject',
        // The submission time is included in the todoUntil date.
        withSubmissions: true,
        todoUntil: DateTime(2024, 03, 12, 16, 30),
        description: 'description text',
        private: false,
      );

      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      expect(find.text('Nächster Schultag'), findsNothing);
      expect(find.text('Nächste Stunde'), findsNothing);
      expect(find.text('Übernächste Stunde'), findsNothing);
      expect(find.text('Benutzerdefiniert'), findsNothing);

      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: false);
      expect(find.text('Nächster Schultag'), findsNothing);
      expect(find.text('Nächste Stunde'), findsNothing);
      expect(find.text('Übernächste Stunde'), findsNothing);
      expect(find.text('Benutzerdefiniert'), findsNothing);
    });

    _TestController createController(WidgetTester tester) {
      return _TestController(
        tester,
        nextLessonCalculator,
        homeworkDialogApi,
        courseGateway,
        setClockOverride: (clock) => clockOverride = clock,
      );
    }

    testWidgets(
        'when pressing "Nächste Stunde" the next lesson will be selected',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course'));
      controller.addNextLessonDates(
          'foo_course', [Date('2023-11-06'), Date('2023-11-08')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.selectLessonChip('Nächste Stunde');

      expect(controller.getSelectedLessonChips(), ['Nächste Stunde']);
      expect(controller.getSelectedDueDate(), Date('2023-11-06'));
    });
    testWidgets(
        'when pressing "Übernächste Stunde" the lesson after next lesson will be selected',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course'));
      controller.addNextLessonDates(
          'foo_course', [Date('2023-11-06'), Date('2023-11-08')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.selectLessonChip('Übernächste Stunde');

      expect(controller.getSelectedLessonChips(), ['Übernächste Stunde']);
      expect(controller.getSelectedDueDate(), Date('2023-11-08'));
    });
    testWidgets(
        'Regression test: When creating a "in 2 lesson" custom chip the "übernächste Stunde" chip will be selected and no custom chip will be created',
        (tester) async {
      // https://github.com/SharezoneApp/sharezone-app/issues/1272

      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course'));
      controller.addNextLessonDates(
          'foo_course', [Date('2023-11-06'), Date('2023-11-08')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      final nrOfChipsBefore = controller.getLessonChips().length;
      await controller.selectCourse('foo_course');
      await controller.createCustomChip(inXLessons: 2);
      final nrOfChipsAfter = controller.getLessonChips().length;

      expect(controller.getSelectedLessonChips(), ['Übernächste Stunde']);
      expect(nrOfChipsBefore, nrOfChipsAfter);
    });
    testWidgets(
        'Regression test: When creating a "in 1 lesson" custom chip the "Nächste Stunde" chip will be selected and no custom chip will be created',
        (tester) async {
      // https://github.com/SharezoneApp/sharezone-app/issues/1272

      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course'));
      controller.addNextLessonDates('foo_course', [Date('2023-11-06')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      final nrOfChipsBefore = controller.getLessonChips().length;
      await controller.selectCourse('foo_course');
      await controller.createCustomChip(inXLessons: 1);
      final nrOfChipsAfter = controller.getLessonChips().length;

      expect(controller.getSelectedLessonChips(), ['Nächste Stunde']);
      expect(nrOfChipsBefore, nrOfChipsAfter);
    });
    testWidgets(
        'when creating a "in 5 lessons" custom chip it will be selected and the correct date will be selected',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates('foo_course', [
        Date('2023-11-06'),
        Date('2023-11-08'),
        Date('2023-11-10'),
        Date('2023-11-13'),
        Date('2023-11-15'),
      ]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.createCustomChip(inXLessons: 5);

      expect(controller.getSelectedLessonChips(), ['5.-nächste Stunde']);
      expect(controller.getSelectedDueDate(), Date('2023-11-15'));
    });
    testWidgets(
        'when pressing the "next schoolday" chip the next schoolday will be selected',
        (tester) async {
      final controller = createController(tester);

      // Friday, thus next schoolday is Monday
      controller.setToday(Date('2023-11-04'));

      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectLessonChip('Nächster Schultag');

      expect(controller.getSelectedLessonChips(), ['Nächster Schultag']);
      expect(controller.getSelectedDueDate(), Date('2023-11-06'));
    });
    testWidgets('when no course is selected then the lesson chips are disabled',
        (tester) async {
      final controller = createController(tester);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      expect(controller.getSelectableLessonChips(), ['Nächster Schultag']);
      final chips = controller
          .getLessonChips()
          .map((e) => (e.$1, selectable: e.selectable))
          .toList();
      expect(chips, [
        ('Nächster Schultag', selectable: true),
        ('Nächste Stunde', selectable: false),
        ('Übernächste Stunde', selectable: false),
        ('Benutzerdefiniert', selectable: false),
      ]);
      // Test that nothing happens when tapping on disabled chips
      await controller.selectLessonChip('Nächste Stunde');
      await controller.selectLessonChip('Übernächste Stunde');
      expect(controller.getSelectedLessonChips(), []);

      // "Benutzerdefiniert" is not selectable, thus it doesn't show the dialog.
      await controller.selectLessonChip('Benutzerdefiniert');
      expect(find.byKey(HwDialogKeys.customLessonChipDialogTextField),
          findsNothing);
    });
    testWidgets(
        'when the date is manually selected that equals the date of a lesson chip then the lesson chip will NOT be selected',
        (tester) async {
      /// We want this behavior to avoid potential confusion in the future.
      /// For now a homework will always be due on the selected due date and
      /// this will only change if a user explicitly changes the due date.
      /// In the future we might allow setting a lesson as canceld, which would
      /// change the due date to the next lesson. Then it might make sense
      /// differentiating between a lesson that had its due date set to "next
      /// lesson" via a chip and a lesson that had the due date set manually to
      /// a specific date. In this case selecting a due date manually and using
      /// a lesson chip would have different behavior. Thus for now we don't
      /// want to make it look that setting a due date manually and using a
      /// lesson chip have the same behavior. This means we won't select the
      /// lesson chip for e.g. "next lesson" if the due date was manually set to
      /// the date of the next lesson.
      final controller = createController(tester);
      // controller.setToday(Date('2023-10-04'));
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates('foo_course', [Date('2023-10-06')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.selectDateManually(Date('2023-10-06'));

      expect(controller.getSelectedDueDate(), Date('2023-10-06'));
      expect(controller.getSelectedLessonChips(), []);
    });
    testWidgets(
        'when the date is manually selected that equals the date of the next schoolday then the corresponding chip will be selected',
        (tester) async {
      final controller = createController(tester);
      // Wednesday
      controller.setToday(Date('2023-12-06'));
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.selectDateManually(Date('2023-12-07'));

      expect(controller.getSelectedDueDate(), Date('2023-12-07'));
      expect(controller.getSelectedLessonChips(), ['Nächster Schultag']);
    });

    testWidgets('when no course is chosen then no chip should be selected',
        (tester) async {
      final controller = createController(tester);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      expect(controller.getSelectedLessonChips(), []);
    });

    testWidgets(
        'when selecting next lesson for a course and changing to a course without any lessons the date should stay but the lesson chip should be deselected',
        (tester) async {
      // This test can pass but in the real app it can still not work. I don't
      // know why :(
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates('foo_course', [Date('2023-10-06')]);
      controller.addCourse(courseWith(id: 'bar_course', name: 'Bar course'));
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.selectCourse('bar_course');

      expect(controller.getSelectedLessonChips(), []);
      expect(controller.getSelectedDueDate(), Date('2023-10-06'));
    });
    testWidgets(
        'regression test: creating a custom chip for a course with lessons and then changing to a course without lessons should display the custom chip as not selectable',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates('foo_course', [
        // Don't matter, just need enough dates so that
        // createCustomChip(inXLessons: 5) works.
        Date('2023-10-06'),
        Date('2023-10-08'),
        Date('2023-10-10'),
        Date('2023-10-13'),
        Date('2023-10-15')
      ]);
      controller.addCourse(courseWith(id: 'bar_course', name: 'Bar course'));
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.createCustomChip(inXLessons: 5);
      await controller.selectCourse('bar_course');

      expect(controller.getSelectableLessonChips(), ['Nächster Schultag']);
    });
    testWidgets(
        'when selecting "Nächster Schultag", then selecting a course with lessons, the old "Nächster Schultag" selection should be kept',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates('foo_course', [Date('2023-10-06')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectLessonChip('Nächster Schultag');
      await controller.selectCourse('foo_course');

      expect(controller.getSelectedLessonChips(), ['Nächster Schultag']);
    });
    testWidgets(
        'when a course without lessons is selected then "Nächster Schultag" should be automatically selected',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');

      expect(controller.getSelectedLessonChips(), ['Nächster Schultag']);
    });
    testWidgets(
        'when first selecting a course with lessons then the "Nächste Stunde" chip will be selected',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates(
          'foo_course', [Date('2023-10-06'), Date('2023-10-08')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');

      expect(controller.getSelectedLessonChips(), ['Nächste Stunde']);
    });
    testWidgets(
        'when selecting a lesson chip and then selecting another course with also lessons then the lesson chip should be kept active but the date should be updated',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates(
          'foo_course', [Date('2023-10-06'), Date('2023-10-08')]);
      controller.addCourse(courseWith(id: 'bar_course', name: 'Bar course'));
      controller.addNextLessonDates(
          'bar_course', [Date('2023-10-08'), Date('2023-10-12')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.selectLessonChip('Übernächste Stunde');
      await controller.selectCourse('bar_course');

      expect(controller.getSelectedLessonChips(), ['Übernächste Stunde']);
      expect(controller.getSelectedDueDate(), Date('2023-10-12'));
    });
    testWidgets(
        'when choosing and then deleting a custom lesson chip then the date will stay the same when selecting another course',
        (tester) async {
      final controller = createController(tester);
      controller.addCourse(courseWith(id: 'foo_course', name: 'Foo course'));
      controller.addNextLessonDates('foo_course',
          [Date('2023-10-06'), Date('2023-10-08'), Date('2023-10-12')]);
      controller.addCourse(courseWith(id: 'bar_course', name: 'Bar course'));
      controller.addNextLessonDates('bar_course',
          [Date('2023-10-08'), Date('2023-10-12'), Date('2023-10-14')]);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectCourse('foo_course');
      await controller.createCustomChip(inXLessons: 3);
      await controller.deleteCustomChip(inXLessons: 3);
      await controller.selectCourse('bar_course');

      expect(controller.getSelectedLessonChips(), []);
      // If we in 3 lessons selection would still exist then the date would be
      // 2023-10-14
      expect(controller.getSelectedDueDate(), Date('2023-10-12'));
    });
  });
}

typedef LessonChip = (String label, {bool isSelected, bool selectable});

class _TestController {
  final MockHomeworkDialogApi homeworkDialogApi;
  // final MockSharezoneContext sharezoneContext;
  // final LocalAnalyticsBackend analyticsBackend;
  // final Analytics analytics;
  // final MockSharezoneGateway sharezoneGateway;
  final MockCourseGateway courseGateway;
  // final MockHomeworkGateway homeworkGateway;
  final WidgetTester tester;
  final MockNextLessonCalculator nextLessonCalculator;
  void Function(Clock clock) setClockOverride;

  _TestController(
    this.tester,
    this.nextLessonCalculator,
    this.homeworkDialogApi,
    this.courseGateway, {
    required this.setClockOverride,
  });

  void setToday(Date date) {
    setClockOverride(Clock.fixed(date.toDateTime));
  }

  Future<void> selectLessonChip(String label) async {
    await tester.ensureVisible(
        find.widgetWithText(InputChip, label, skipOffstage: false));
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  List<LessonChip> _getChips() {
    final chips = tester
        .widgetList<InputChip>(find.byType(InputChip, skipOffstage: false));
    return chips
        .map((e) => (
              (e.label as Text).data!,
              isSelected: e.selected,
              // Normal chips use onSelected, "Benutzerdefiniert" (custom value)
              // chip uses onPressed.
              // If onDeleted is not-null but everything else is null the chip
              // looks like it's selectable in the UI, but it is only deletable,
              // not selectable. To avoid confusion we explicitly mark it as
              // selectable here so that developers know about this behavior and
              // set onDeleted explicitly to null. Not being able to delete the
              // chip if it is not selectable shouldn't be a problem for users.
              selectable: e.onSelected != null ||
                  e.onPressed != null ||
                  e.onDeleted != null,
            ))
        .toList();
  }

  List<String> getSelectedLessonChips() {
    final res = _getChips().where((element) => element.isSelected);
    return res.map((e) => e.$1).toList();
  }

  List<LessonChip> getLessonChips() {
    return _getChips();
  }

  List<String> getSelectableLessonChips() {
    return _getChips()
        .where((element) => element.selectable)
        .map((e) => e.$1)
        .toList();
  }

  Date? getSelectedDueDate() {
    final datePicker = tester.widget<DatePicker>(find.byType(DatePicker));
    return datePicker.selectedDate?.toDate();
  }

  void setNextSchoolday(Date date) {}

  final _addedCourses = <String, Course>{};
  void addCourse(Course course) {
    _addedCourses[course.id] = course;
    when(courseGateway.streamCourses())
        .thenAnswer((_) => Stream.value(_addedCourses.values.toList()));
    homeworkDialogApi.addCourseForTesting(course);
  }

  Future<void> selectCourse(String courseId) async {
    await tester.ensureVisible(
        find.byKey(HwDialogKeys.courseTile, skipOffstage: false));
    final course = _addedCourses[courseId];
    if (course == null) {
      throw ArgumentError('Course with id $courseId not found');
    }
    await tester.tap(find.byKey(HwDialogKeys.courseTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text(course.name));
    await tester.pumpAndSettle();
  }

  void addNextLessonDates(String courseId, List<Date> nextDates) {
    nextLessonCalculator.returnLessonsForCourse(courseId, nextDates);
  }

  Future<void> createCustomChip({required int inXLessons}) async {
    await selectLessonChip('Benutzerdefiniert');
    await tester.enterText(
        find.byKey(HwDialogKeys.customLessonChipDialogTextField),
        '$inXLessons');
    await tester.tap(find.byKey(HwDialogKeys.customLessonChipDialogOkButton));
    await tester.pumpAndSettle();
  }

  Future<void> selectDateManually(Date date) async {
    // This is kinda hacky, but selecting a date manually via the UI is very
    // difficult, I couldn't get it working. So this has to do for now.
    tester
        .widget<DatePicker>(find.byType(DatePicker))
        .selectDate!(date.toDateTime);
    await tester.pumpAndSettle();
  }

  Future<void> deleteCustomChip({required int inXLessons}) async {
    // For now only works if only one custom chip exists.
    await tester.tap(find.byKey(HwDialogKeys.lessonChipDeleteIcon));
    await tester.pumpAndSettle();
  }
}

// Used temporarily when testing so one can see what happens "on the screen" in
// a widget test without having to use a real device / simulator to run these
// tests.
// --update-goldens
Future<void> generateGolden(String name) async {
  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('goldens/golden_$name.png'));
}
