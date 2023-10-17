// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';
import 'dart:typed_data';

import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:time/time.dart';

import '../analytics/analytics_test.dart';
import 'homework_dialog_test.dart';
import 'homework_dialog_test.mocks.dart';

void main() {
  group('HomeworkDialogBloc', () {
    late MockCourseGateway courseGateway;
    late MockHomeworkDialogApi homeworkDialogApi;
    late MockNextLessonCalculator nextLessonCalculator;
    late MockSharezoneContext sharezoneContext;
    late LocalAnalyticsBackend analyticsBackend;
    late Analytics analytics;

    setUp(() {
      courseGateway = MockCourseGateway();
      homeworkDialogApi = MockHomeworkDialogApi();
      nextLessonCalculator = MockNextLessonCalculator();
      sharezoneContext = MockSharezoneContext();
      analyticsBackend = LocalAnalyticsBackend();
      analytics = Analytics(analyticsBackend);
    });

    HomeworkDialogBloc createBlocForNewHomeworkDialog() {
      return HomeworkDialogBloc(
          api: homeworkDialogApi, nextLessonCalculator: nextLessonCalculator);
    }

    HomeworkDialogBloc createBlocForEditingHomeworkDialog(HomeworkId id) {
      return HomeworkDialogBloc(
        api: homeworkDialogApi,
        nextLessonCalculator: nextLessonCalculator,
        homeworkId: id,
      );
    }

    void addCourse(Course course) {
      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([course]));
      homeworkDialogApi.addCourseForTesting(course);
    }

    // TODO: Test edit dialog
    test(
        'Shows error if title is not filled out when creating a new homework and Submit is called',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const Submit());
      await pumpEventQueue();
      Ready state = bloc.state as Ready;
      expect(state.title.error, const EmptyTitleException());
    });
    test('Removes error if title is changed to a valid value', () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const Submit());
      await pumpEventQueue();
      bloc.add(const TitleChanged('Foo'));
      await pumpEventQueue();
      final state = bloc.state as Ready;
      expect(state.title.error, null);
    });
    // TODO: Test edit dialog
    test(
        'Shows error if course is not selected out when creating a new homework and Submit is called',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));
      bloc.add(const Submit());

      Ready state = await bloc.stream.whereType<Ready>().first;
      final courseState = state.course as NoCourseChosen;
      expect(courseState.error, const NoCourseChosenException());
    });
    // TODO: Test edit dialog
    test(
        'Shows error if due date is not selected when creating a new homework and Submit is called',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const Submit());

      Ready state = await bloc.stream.whereType<Ready>().first;
      expect(state.dueDate.error, const NoDueDateSelectedException());
    });
    test(
        'if a date has been manually set it wont be overridden by next lesson date',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));
      nextLessonCalculator.dateToReturn = Date('2023-04-02');
      bloc.add(DueDateChanged(Date('2023-03-28')));
      bloc.add(CourseChanged(CourseId('foo_course')));

      Ready state = await bloc.stream
          .whereType<Ready>()
          .where((event) => event.course is CourseChosen)
          .first;

      // Due date might be delayed because of async next lesson calculation
      await pumpEventQueue();
      state = bloc.state as Ready;

      expect(state.dueDate.$1, Date('2023-03-28'));
    });
    test('Removes error if due date is changed to a valid value', () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const Submit());
      await pumpEventQueue();
      bloc.add(DueDateChanged(Date('2023-10-12')));
      await pumpEventQueue();
      final state = bloc.state as Ready;
      expect(state.dueDate.error, null);
    });
    test('Picks the next lesson as due date when a course is selected',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      bloc.add(CourseChanged(CourseId('foo_course')));

      final state = await bloc.stream
          .whereType<Ready>()
          .firstWhere((element) => element.dueDate.$1 != null);
      expect(state.dueDate.$1, nextLessonDate);
    });
    test(
        'leaves due date as not selected if null is returned by $NextLessonCalculator',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));

      bloc.add(CourseChanged(CourseId('foo_course')));

      nextLessonCalculator.dateToReturn = null;
      await bloc.stream
          .whereType<Ready>()
          .firstWhere((element) => element.course is CourseChosen);

      // Make sure that we wait for the due date to be set (might be delayed,
      // after the course is set and returned by the view)
      await pumpEventQueue(times: 100);
      await Future.delayed(Duration.zero);
      await pumpEventQueue(times: 100);

      final state = bloc.state as Ready;
      expect(state.dueDate.$1, null);
    });
    test('Returns empty dialog when called for creating a new homework', () {
      final bloc = createBlocForNewHomeworkDialog();
      expect(bloc.state, emptyCreateHomeworkDialogState);
    });
    test('Sucessfully add private homework with files', () async {
      final bloc = createBlocForNewHomeworkDialog();

      final mathCourse = courseWith(
        id: 'maths_course',
        name: 'Maths',
        subject: 'Math',
      );
      addCourse(mathCourse);

      final fooLocalFile = randomLocalFileFrom(path: 'bar/foo.png');
      final barLocalFile = randomLocalFileFrom(path: 'foo/bar.pdf');
      final quzLocalFile = randomLocalFileFrom(path: 'bar/quux/baz/quz.mp4');

      bloc.add(const TitleChanged('S. 32 8a)'));
      bloc.add(CourseChanged(CourseId(mathCourse.id)));
      bloc.add(DueDateChanged(Date.parse('2023-10-12')));
      bloc.add(const DescriptionChanged('This is a description'));
      bloc.add(const IsPrivateChanged(true));
      // Create new test with more testing of removing/adding files (and remove
      // removing files here)
      bloc.add(
          AttachmentsAdded(IList([fooLocalFile, barLocalFile, quzLocalFile])));
      bloc.add(AttachmentRemoved(quzLocalFile.fileId));
      await pumpEventQueue();

      expect(
          bloc.state,
          Ready(
            title: ('S. 32 8a)', error: null),
            course: CourseChosen(
              courseId: CourseId(mathCourse.id),
              courseName: 'Maths',
              isChangeable: true,
            ),
            dueDate: (Date('2023-10-12'), error: null),
            submissions: const SubmissionsDisabled(isChangeable: false),
            description: 'This is a description',
            attachments: IList([
              FileView(
                  fileId: fooLocalFile.fileId,
                  fileName: 'foo.png',
                  format: FileFormat.image,
                  localFile: fooLocalFile),
              FileView(
                  fileId: barLocalFile.fileId,
                  fileName: 'bar.pdf',
                  format: FileFormat.pdf,
                  localFile: barLocalFile),
            ]),
            notifyCourseMembers: false,
            isPrivate: (true, isChangeable: true),
            hasModifiedData: true,
            isEditing: false,
          ));

      bloc.add(const Submit());

      await pumpEventQueue();

      expect(bloc.state, const SavedSucessfully(isEditing: false));
      expect(
          homeworkDialogApi.userInputToBeCreated,
          UserInput(
            title: 'S. 32 8a)',
            todoUntil: DateTime(2023, 10, 12),
            description: 'This is a description',
            withSubmission: false,
            localFiles: IList([fooLocalFile, barLocalFile]),
            sendNotification: false,
            private: true,
          ));
    });
    test('Sucessfully add homework with submissions', () async {
      final bloc = createBlocForNewHomeworkDialog();

      final artCourse = courseWith(
        id: 'art_course',
        name: 'Art',
        subject: 'Art',
      );

      addCourse(artCourse);

      bloc.add(const TitleChanged('Paint masterpiece'));
      bloc.add(CourseChanged(CourseId(artCourse.id)));
      bloc.add(DueDateChanged(Date.parse('2024-11-13')));
      bloc.add(SubmissionsChanged(
          (enabled: true, submissionTime: Time(hour: 16, minute: 30))));
      bloc.add(const DescriptionChanged('This is a description'));
      bloc.add(const NotifyCourseMembersChanged(true));
      await pumpEventQueue();

      expect(
          bloc.state,
          Ready(
            title: ('Paint masterpiece', error: null),
            course: CourseChosen(
              courseId: CourseId(artCourse.id),
              courseName: 'Art',
              isChangeable: true,
            ),
            dueDate: (Date('2024-11-13'), error: null),
            submissions:
                SubmissionsEnabled(deadline: Time(hour: 16, minute: 30)),
            description: 'This is a description',
            attachments: IList(),
            notifyCourseMembers: true,
            isPrivate: (false, isChangeable: false),
            hasModifiedData: true,
            isEditing: false,
          ));

      bloc.add(const Submit());

      await pumpEventQueue();

      expect(bloc.state, const SavedSucessfully(isEditing: false));
      expect(
          homeworkDialogApi.userInputToBeCreated,
          UserInput(
            title: 'Paint masterpiece',
            todoUntil: DateTime(2024, 11, 13, 16, 30),
            description: 'This is a description',
            withSubmission: true,
            localFiles: IList(const []),
            sendNotification: true,
            private: false,
          ));
    });
    test('Returns loading state when called for an existing homework', () {
      final homeworkId = HomeworkId('foo');
      final bloc = createBlocForEditingHomeworkDialog(homeworkId);

      expect(bloc.state, LoadingHomework(homeworkId, isEditing: true));
    });
    test('when submissions are toggled 23:59 is used as the default value',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const SubmissionsChanged((enabled: true, submissionTime: null)));
      await pumpEventQueue();
      final state = bloc.state as Ready;
      expect(state.submissions,
          SubmissionsEnabled(deadline: Time(hour: 23, minute: 59)));
    });
    test(
        'Regression test: When choosing due date then the submission time should not reset to 00:00',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      await pumpEventQueue();
      bloc.add(DueDateChanged(Date('2024-03-08')));
      bloc.add(const SubmissionsChanged((enabled: true, submissionTime: null)));
      await pumpEventQueue();
      final state = bloc.state as Ready;
      expect(state.submissions,
          SubmissionsEnabled(deadline: Time(hour: 23, minute: 59)));
    });
    test(
        'regression test: No due date is automatically set when starting to change data',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const TitleChanged('abc'));
      await pumpEventQueue();
      final state = bloc.state as Ready;
      expect(state.dueDate.$1, null);
    });
    test('Sucessfully displays and edits existing homework', () async {
      final homeworkId = HomeworkId('foo_homework_id');

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

      final homework = randomHomeworkWith(
        id: homeworkId.id,
        title: 'title text',
        courseId: 'foo_course',
        courseName: 'Foo course',
        withSubmissions: false,
        todoUntil: DateTime(2024, 03, 12),
        description: 'description text',
        attachments: ['foo_attachment_id1', 'foo_attachment2.png'],
        private: true,
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await pumpEventQueue();

      bloc.add(AttachmentRemoved(FileId('foo_attachment_id1')));

      await pumpEventQueue();
      expect(
        bloc.state,
        Ready(
          title: ('title text', error: null),
          course: CourseChosen(
            courseId: CourseId('foo_course'),
            courseName: 'Foo course',
            isChangeable: false,
          ),
          dueDate: (Date('2024-03-12'), error: null),
          submissions: const SubmissionsDisabled(isChangeable: false),
          description: 'description text',
          attachments: IList([
            FileView(
                fileId: FileId('foo_attachment_id2'),
                fileName: 'foo_attachment2.pdf',
                format: FileFormat.pdf,
                cloudFile: attachment2),
          ]),
          notifyCourseMembers: false,
          isPrivate: (true, isChangeable: false),
          hasModifiedData: true,
          isEditing: true,
        ),
      );

      bloc.add(const Submit());
      await pumpEventQueue();

      expect(
        homeworkDialogApi.userInputFromEditing,
        UserInput(
          title: 'title text',
          withSubmission: false,
          todoUntil: DateTime(2024, 03, 12),
          description: 'description text',
          localFiles: IList(),
          private: true,
          sendNotification: false,
        ),
      );
      expect(homeworkDialogApi.removedCloudFilesFromEditing, [attachment1]);
      expect(bloc.state, const SavedSucessfully(isEditing: true));
    });
    test('Sucessfully displays and edits existing homework 2', () async {
      final homeworkId = HomeworkId('bar_homework_id');

      final barCourse = courseWith(
        id: 'bar_course',
        name: 'Bar course',
        subject: 'Bar subject',
      );

      addCourse(barCourse);
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      final mockDocumentReference = MockDocumentReference();
      when(mockDocumentReference.id).thenReturn('bar_course');

      final homework = randomHomeworkWith(
        id: homeworkId.id,
        title: 'title text',
        courseId: 'bar_course',
        courseName: 'Bar course',
        withSubmissions: true,
        todoUntil: DateTime(2024, 03, 12, 16, 35),
        description: 'description text',
        attachments: [],
        sendNotification: true,
        private: false,
      );

      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await pumpEventQueue();
      expect(
        bloc.state,
        Ready(
          title: ('title text', error: null),
          course: CourseChosen(
            courseId: CourseId('bar_course'),
            courseName: 'Bar course',
            isChangeable: false,
          ),
          dueDate: (Date('2024-03-12'), error: null),
          submissions: SubmissionsEnabled(deadline: Time(hour: 16, minute: 35)),
          description: 'description text',
          attachments: IList(),
          notifyCourseMembers: false,
          isPrivate: (false, isChangeable: false),
          hasModifiedData: false,
          isEditing: true,
        ),
      );

      bloc.add(const Submit());
      await pumpEventQueue();

      expect(
        homeworkDialogApi.userInputFromEditing,
        UserInput(
          title: 'title text',
          withSubmission: true,
          todoUntil: DateTime(2024, 03, 12, 16, 35),
          description: 'description text',
          localFiles: IList(),
          private: false,
          sendNotification: false,
        ),
      );
      expect(homeworkDialogApi.removedCloudFilesFromEditing, []);

      expect(bloc.state, const SavedSucessfully(isEditing: true));
    });
  });
}

class FakeLocalFile extends LocalFile {
  final File? file;
  final Uint8List? fileData;
  final String fileName;
  final int sizeBytes;
  final MimeType? mimeType;
  final String? path;

  FakeLocalFile({
    this.file,
    this.fileData,
    required this.fileName,
    this.path,
    required this.sizeBytes,
    this.mimeType,
  });

  factory FakeLocalFile.empty({String name = '', MimeType? mimeType}) {
    return FakeLocalFile(
      file: null,
      fileData: Uint8List(0),
      sizeBytes: 0,
      path: null,
      mimeType: null,
      fileName: name,
    );
  }

  factory FakeLocalFile.fromData(
      Uint8List data, String? path, String name, String? type) {
    return FakeLocalFile(
      file: null,
      fileData: data,
      sizeBytes: data.lengthInBytes,
      path: path,
      mimeType: type == null ? null : MimeType(type),
      fileName: name,
    );
  }

  @override
  getFile() {
    return file;
  }

  @override
  getData() {
    return fileData;
  }

  @override
  String? getPath() {
    return path;
  }

  @override
  MimeType? getType() {
    return mimeType;
  }

  @override
  String getName() {
    return fileName;
  }

  @override
  int getSizeBytes() {
    return sizeBytes;
  }
}
