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
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
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

    test('Picks the next lesson as due date when a course is selected',
        () async {
      final homeworkId = HomeworkId('foo_homework_id');
      final bloc = createBlocForNewHomeworkDialog();

      final fooCourse = Course.create().copyWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
        abbreviation: 'F',
        myRole: MemberRole.admin,
      );

      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([fooCourse]));
      homeworkDialogApi.courseToReturn = fooCourse;
      when(sharezoneContext.analytics).thenReturn(analytics);
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([fooCourse]));

      bloc.add(CourseChanged(CourseId('foo_course')));
      await pumpEventQueue();
      await Future.delayed(Duration(seconds: 1));
      await pumpEventQueue();
      await pumpEventQueue();

      final state = bloc.state as Ready;
      expect(state.dueDate, nextLessonDate);
    });
    test('Returns empty dialog when called for creating a new homework', () {
      final bloc = createBlocForNewHomeworkDialog();
      expect(bloc.state, emptyCreateHomeworkDialogState);
    });
    test('Sucessfully add private homework with files', () async {
      final bloc = createBlocForNewHomeworkDialog();

      final mathCourse = Course.create().copyWith(
        id: 'maths_course',
        name: 'Maths',
        subject: 'Math',
        abbreviation: 'M',
        myRole: MemberRole.admin,
      );

      final fooLocalFile = FakeLocalFile.fromData(
          Uint8List.fromList([1, 2]), 'bar/foo.png', 'foo.png', 'png');
      final barLocalFile = FakeLocalFile.fromData(
          Uint8List.fromList([1, 2, 3, 4]), 'foo/bar.pdf', 'bar.pdf', 'pdf');
      final quzLocalFile = FakeLocalFile.fromData(
          Uint8List.fromList([9]), 'bar/quux/baz/quz.pdf', 'quz.mp4', 'mp4');

      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([mathCourse]));
      homeworkDialogApi.courseToReturn = mathCourse;

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
            title: 'S. 32 8a)',
            course: CourseChosen(
              courseId: CourseId(mathCourse.id),
              courseName: 'Maths',
              isChangeable: true,
            ),
            dueDate: Date('2023-10-12'),
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

      final artCourse = Course.create().copyWith(
        id: 'art_course',
        name: 'Art',
        subject: 'Art',
        abbreviation: 'A',
        myRole: MemberRole.admin,
      );

      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([artCourse]));
      homeworkDialogApi.courseToReturn = artCourse;

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
            title: 'Paint masterpiece',
            course: CourseChosen(
              courseId: CourseId(artCourse.id),
              courseName: 'Art',
              isChangeable: true,
            ),
            dueDate: Date('2024-11-13'),
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
      expect(state.dueDate, null);
    });
    test('Sucessfully displays and edits existing homework', () async {
      final homeworkId = HomeworkId('foo_homework_id');

      final fooCourse = Course.create().copyWith(
        id: 'foo_course',
        name: 'Foo course',
        subject: 'Foo subject',
        abbreviation: 'F',
        myRole: MemberRole.admin,
      );

      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([fooCourse]));
      homeworkDialogApi.courseToReturn = fooCourse;
      when(sharezoneContext.analytics).thenReturn(analytics);
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      homeworkDialogApi.loadCloudFilesResult.addAll([
        CloudFile.create(
                id: 'foo_attachment_id1',
                creatorName: 'Assignment Creator Name 1',
                courseID: 'foo_course',
                creatorID: 'foo_creator_id',
                path: FolderPath.fromPathString(
                    '/foo_course/${FolderPath.attachments}'))
            .copyWith(
                name: 'foo_attachment1.png', fileFormat: FileFormat.image),
        CloudFile.create(
                id: 'foo_attachment_id2',
                creatorName: 'Assignment Creator Name 2',
                courseID: 'foo_course',
                creatorID: 'foo_creator_id',
                path: FolderPath.fromPathString(
                    '/foo_course/${FolderPath.attachments}'))
            .copyWith(name: 'foo_attachment2.pdf', fileFormat: FileFormat.pdf),
      ]);

      final mockDocumentReference = MockDocumentReference();
      when(mockDocumentReference.id).thenReturn('foo_course');
      final homework = HomeworkDto.create(
              courseID: 'foo_course', courseReference: mockDocumentReference)
          .copyWith(
        id: homeworkId.id,
        title: 'title text',
        courseID: 'foo_course',
        courseName: 'Foo course',
        subject: 'Foo subject',
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
          title: 'title text',
          course: CourseChosen(
            courseId: CourseId('foo_course'),
            courseName: 'Foo course',
            isChangeable: false,
          ),
          dueDate: Date('2024-03-12'),
          submissions: const SubmissionsDisabled(isChangeable: false),
          description: 'description text',
          attachments: IList([
            FileView(
                fileId: FileId('foo_attachment_id2'),
                fileName: 'foo_attachment2.pdf',
                format: FileFormat.pdf,
                cloudFile: homeworkDialogApi.loadCloudFilesResult[1]),
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
      expect(homeworkDialogApi.removedCloudFilesFromEditing,
          [homeworkDialogApi.loadCloudFilesResult[0]]);

      expect(bloc.state, const SavedSucessfully(isEditing: true));
    });
    test('Sucessfully displays and edits existing homework 2', () async {
      final homeworkId = HomeworkId('bar_homework_id');

      final barCourse = Course.create().copyWith(
        id: 'bar_course',
        name: 'Bar course',
        subject: 'Bar subject',
        abbreviation: 'B',
        myRole: MemberRole.admin,
      );

      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([barCourse]));
      homeworkDialogApi.courseToReturn = barCourse;
      when(sharezoneContext.analytics).thenReturn(analytics);
      final nextLessonDate = Date('2024-03-08');
      nextLessonCalculator.dateToReturn = nextLessonDate;

      final mockDocumentReference = MockDocumentReference();
      when(mockDocumentReference.id).thenReturn('bar_course');
      final homework = HomeworkDto.create(
              courseID: 'bar_course', courseReference: mockDocumentReference)
          .copyWith(
        id: homeworkId.id,
        title: 'title text',
        courseID: 'bar_course',
        courseName: 'Bar course',
        subject: 'Bar subject',
        withSubmissions: true,
        todoUntil: DateTime(2024, 03, 12, 16, 35),
        description: 'description text',
        attachments: [],
        // Sometimes sendNotficiation might be set to true for an existing
        // homework, but we need to make sure that it will be ignored.
        sendNotification: true,
        private: false,
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await pumpEventQueue();
      expect(
        bloc.state,
        Ready(
          title: 'title text',
          course: CourseChosen(
            courseId: CourseId('bar_course'),
            courseName: 'Bar course',
            isChangeable: false,
          ),
          dueDate: Date('2024-03-12'),
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

  FakeLocalFile._({
    required this.file,
    required this.fileData,
    required this.fileName,
    required this.path,
    required this.sizeBytes,
    required this.mimeType,
  });

  factory FakeLocalFile.empty({String name = '', MimeType? mimeType}) {
    return FakeLocalFile._(
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
    return FakeLocalFile._(
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
