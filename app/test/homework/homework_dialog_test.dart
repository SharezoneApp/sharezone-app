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
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/src/homework_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:random_string/random_string.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
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
  @override
  Future<Date?> tryCalculateNextLesson(String courseID) async {
    return dateToReturn;
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
      await tester
          .ensureVisible(find.byKey(HwDialogKeys.notifyCourseMembersTile));
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
    testWidgets('when pressing a homework lesson chip it gets selected',
        (tester) async {
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await tester.tap(find.text('Nächster Schultag'));
      await tester.pumpAndSettle();

      final chips = tester.widgetList<InputChip>(find.byType(InputChip));
      final mapped =
          chips.map((e) => ((e.label as Text).data!, e.selected)).toList();

      expect(mapped, [
        ('Nächster Schultag', true),
        ('Nächste Stunde', false),
        ('Übernächste Stunde', false),
        ('Benutzerdefiniert', false),
      ]);
    });

    _TestController createController(WidgetTester tester) {
      return _TestController(
        tester,
        nextLessonCalculator,
        setClockOverride: (clock) => clockOverride = clock,
      );
    }

    testWidgets(
        'when pressing the "next schoolday" chip the next schoolday will be selected',
        (tester) async {
      final controller = createController(tester);

      // controller.setNextSchoolday(Date('2023-11-06'));
      // Friday
      controller.setToday(Date('2023-11-04'));
      // controller.setSchooldays('Mo-Fr');
      // expect(controller.isRegularSchoolday(Date('2023-11-06')), true);

      // await controller.pumpAndSettleHomeworkDialog(
      //     showDueDateSelectionChips: true);
      await pumpAndSettleHomeworkDialog(tester,
          showDueDateSelectionChips: true);

      await controller.selectLessonChip('Nächster Schultag');

      expect(controller.getSelectedLessonChips(), ['Nächster Schultag']);
      expect(controller.getSelectedDueDate(), Date('2023-11-06'));
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
  });
}

class _TestController {
  final WidgetTester tester;
  final MockNextLessonCalculator nextLessonCalculator;
  void Function(Clock clock) setClockOverride;

  _TestController(
    this.tester,
    this.nextLessonCalculator, {
    required this.setClockOverride,
  });

  void setToday(Date date) {
    setClockOverride(Clock.fixed(date.toDateTime));
  }

  Future<void> selectLessonChip(String s) async {
    await tester.tap(find.text('Nächster Schultag'));
    await tester.pumpAndSettle();
  }

  List<String> getSelectedLessonChips() {
    final chips = tester.widgetList<InputChip>(find.byType(InputChip));
    final res = chips
        .map((e) => ((e.label as Text).data!, isSelected: e.selected))
        .where((element) => element.isSelected);
    return res.map((e) => e.$1).toList();
  }

  Date? getSelectedDueDate() {
    final datePicker = tester.widget<DatePicker>(find.byType(DatePicker));
    return datePicker.selectedDate?.toDate();
  }

  void setNextSchoolday(Date date) {}
}

// Used temporarily when testing so one can see what happens "on the screen" in
// a widget test without having to use a real device / simulator to run these
// tests.
// --update-goldens
Future<void> generateGolden(String name) async {
  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('goldens/golden_$name.png'));
}
