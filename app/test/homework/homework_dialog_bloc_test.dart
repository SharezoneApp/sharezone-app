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
import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog_bloc.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

import '../analytics/analytics_test.dart';
import 'homework_dialog_test.dart';
import 'homework_dialog_test.mocks.dart';

void main() {
  group('HomeworkDialogBloc', () {
    late MockCourseGateway courseGateway;
    late MockHomeworkDialogApi homeworkDialogApi;
    late MockNextLessonCalculator nextLessonCalculator;
    late LocalAnalyticsBackend analyticsBackend;
    late Analytics analytics;

    setUp(() {
      courseGateway = MockCourseGateway();
      homeworkDialogApi = MockHomeworkDialogApi();
      nextLessonCalculator = MockNextLessonCalculator();
      analyticsBackend = LocalAnalyticsBackend();
      analytics = Analytics(analyticsBackend);
    });

    HomeworkDialogBloc createBlocForNewHomeworkDialog({Clock? clock}) {
      return HomeworkDialogBloc(
        api: homeworkDialogApi,
        clockOverride: clock,
        nextLessonCalculator: nextLessonCalculator,
        analytics: analytics,
        markdownAnalytics: MarkdownAnalytics(analytics),
        enabledWeekdays: EnabledWeekDays.standard.getEnabledWeekDaysList(),
      );
    }

    HomeworkDialogBloc createBlocForEditingHomeworkDialog(HomeworkId id) {
      return HomeworkDialogBloc(
        api: homeworkDialogApi,
        nextLessonCalculator: nextLessonCalculator,
        analytics: analytics,
        homeworkId: id,
        markdownAnalytics: MarkdownAnalytics(analytics),
        enabledWeekdays: EnabledWeekDays.standard.getEnabledWeekDaysList(),
      );
    }

    void addCourse(Course course) {
      when(courseGateway.streamCourses())
          .thenAnswer((_) => Stream.value([course]));
      homeworkDialogApi.addCourseForTesting(course);
    }

    test('If no next lesson date is found the next weekday will be taken',
        () async {
      Future<void> testNextLessonDate(
          String currentDate, String expectedLessonDate) async {
        // The course does not have any lessons in the timetable, so we fallback
        // to automatically using the next schoolday. We currently assume that
        // all users have schooldays from Monday to Friday. We also don't take
        // holidays into account.
        nextLessonCalculator.dateToReturn = null;
        final testClock = Clock.fixed(Date.parse(currentDate).toDateTime);
        addCourse(courseWith(id: 'foo'));
        final bloc = createBlocForNewHomeworkDialog(clock: testClock);

        bloc.add(const CourseChanged(CourseId('foo')));
        await pumpEventQueue();

        final state = bloc.state as Ready;
        expect(state.dueDate.$1, Date.parse(expectedLessonDate));
      }

      //                    | Current date  | Next lesson date |
      //                          Friday        Monday
      await testNextLessonDate('2023-10-06', '2023-10-09');
      //                         Saturday       Monday
      await testNextLessonDate('2023-10-07', '2023-10-09');
      //                          Sunday        Monday
      await testNextLessonDate('2023-10-08', '2023-10-09');
      //                          Monday        Tuesday
      await testNextLessonDate('2023-10-09', '2023-10-10');
      //                          Tuesday      Wednesday
      await testNextLessonDate('2023-10-10', '2023-10-11');
      //                         Wednesday      Thursday
      await testNextLessonDate('2023-10-11', '2023-10-12');
      //                         Thursday       Friday
      await testNextLessonDate('2023-10-12', '2023-10-13');
    });

    test(
        'Shows error if title is not filled out when creating a new homework and Save is called',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const Save());
      await pumpEventQueue();
      Ready state = bloc.state as Ready;
      expect(state.title.error, const EmptyTitleException());
    });
    test('Removes error if title is changed to a valid value', () async {
      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const Save());
      await pumpEventQueue();
      bloc.add(const TitleChanged('Foo'));
      await pumpEventQueue();
      final state = bloc.state as Ready;
      expect(state.title.error, null);
    });
    test(
        'Shows error and emits presentation event if title is set to blank when editing a homework and Save is called',
        () async {
      const homeworkId = HomeworkId('foo_homework_id');
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final homework = randomHomeworkWith(
        id: homeworkId.value,
        title: 'title text',
        courseId: 'foo_course',
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await bloc.stream.whereType<Ready>().first;

      bloc.add(const TitleChanged(''));
      bloc.add(const Save());

      expect(bloc.presentation, emits(const RequiredFieldsNotFilledOut()));
      Ready state = await bloc.stream
          .whereType<Ready>()
          .firstWhere((event) => event.title.error != null);
      expect(state.title.error, const EmptyTitleException());
    });
    test(
        'Removes error if title is changed to a valid value (editing homework)',
        () async {
      const homeworkId = HomeworkId('foo_homework_id');
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final homework = randomHomeworkWith(
        id: homeworkId.value,
        title: 'title text',
        courseId: 'foo_course',
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await bloc.stream.whereType<Ready>().first;

      bloc.add(const TitleChanged(''));
      await pumpEventQueue();
      bloc.add(const TitleChanged('Foo'));

      final state = await bloc.stream.whereType<Ready>().first;
      expect(state.title.error, null);
    });
    test(
        'Shows error and emits presentation event if course is not selected out when creating a new homework and Save is called',
        () async {
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final bloc = createBlocForNewHomeworkDialog();
      assert(bloc.state is Ready);

      bloc.add(const Save());

      expect(bloc.presentation, emits(const RequiredFieldsNotFilledOut()));
      Ready state = await bloc.stream.whereType<Ready>().first;
      final courseState = state.course as NoCourseChosen;
      expect(courseState.error, const NoCourseChosenException());
    });
    test(
        'Shows error and emits presentation event if due date is not selected when creating a new homework and Save is called',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      assert(bloc.state is Ready);

      bloc.add(const Save());

      expect(bloc.presentation, emits(const RequiredFieldsNotFilledOut()));
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
      bloc.add(DueDateChanged(DueDateSelection.date(Date('2023-03-28'))));
      bloc.add(const CourseChanged(CourseId('foo_course')));

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
      bloc.add(const Save());
      await pumpEventQueue();
      bloc.add(DueDateChanged(DueDateSelection.date(Date('2023-10-12'))));
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

      bloc.add(const CourseChanged(CourseId('foo_course')));

      final state = await bloc.stream
          .whereType<Ready>()
          .firstWhere((element) => element.dueDate.$1 != null);
      expect(state.dueDate.$1, nextLessonDate);
    });
    test('Returns empty dialog when called for creating a new homework', () {
      final bloc = createBlocForNewHomeworkDialog();
      expect(bloc.state, emptyCreateHomeworkDialogState);
    });
    test('emits presentation event if saving the homework fails', () async {
      final bloc = createBlocForNewHomeworkDialog();

      final exception =
          Exception('Something went wrong when creating the homework! :((');
      homeworkDialogApi.createHomeworkError = exception;

      final mathCourse = courseWith(
        id: 'maths_course',
        name: 'Maths',
        subject: 'Math',
      );
      addCourse(mathCourse);
      final fooLocalFile = randomLocalFileFrom(path: 'bar/foo.png');

      await pumpEventQueue();
      bloc.add(const TitleChanged('S. 32 8a)'));
      bloc.add(CourseChanged(CourseId(mathCourse.id)));
      bloc.add(DueDateChanged(DueDateSelection.date(Date.parse('2023-10-12'))));
      // We add an attachment here because otherwise the bloc won't await the
      // future when creating the homework because of the firestore offline
      // behavior (await won't complete). In this case the try-catch doesn't
      // work, currently we don't handle these errors. There might be a solution
      // with Zones (handleUncaughtError), but this is not implemented yet.
      bloc.add(AttachmentsAdded(IList([fooLocalFile])));
      bloc.add(const Save());

      final presentationEvents = bloc.presentation;
      expectLater(
        presentationEvents,
        emitsThrough(predicate<SavingFailed>(
            (event) => event.error == exception && event.stackTrace != null)),
      );
    });
    test('emits presentation event if saving an edited homework fails',
        () async {
      const homeworkId = HomeworkId('foo_homework_id');
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final homework = randomHomeworkWith(
        id: homeworkId.value,
        title: 'title text',
        courseId: 'foo_course',
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final exception =
          Exception('Something went wrong when editing the homework! :((');
      homeworkDialogApi.editHomeworkError = exception;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await bloc.stream.whereType<Ready>().first;

      // We add an attachment here because otherwise the bloc won't await the
      // future when editing because of the firestore offline behavior (await
      // won't complete). In this case the try-catch doesn't work, currently we
      // don't handle these errors. There might be a solution with Zones
      // (handleUncaughtError), but this is not implemented yet.
      bloc.add(
          AttachmentsAdded(IList([randomLocalFileFrom(path: 'foo/bar.png')])));
      bloc.add(const Save());

      final presentationEvents = bloc.presentation;
      expectLater(
        presentationEvents,
        emitsThrough(predicate<SavingFailed>(
            (event) => event.error == exception && event.stackTrace != null)),
      );
    });
    test('Sucessfully add private homework with files', () async {
      final mathCourse = courseWith(
        id: 'maths_course',
        name: 'Maths',
        subject: 'Math',
      );
      addCourse(mathCourse);
      nextLessonCalculator.dateToReturn = Date('2023-10-12');

      final fooLocalFile = randomLocalFileFrom(path: 'bar/foo.png');
      final barLocalFile = randomLocalFileFrom(path: 'foo/bar.pdf');
      final quzLocalFile = randomLocalFileFrom(path: 'bar/quux/baz/quz.mp4');

      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const TitleChanged('S. 32 8a)'));
      bloc.add(CourseChanged(CourseId(mathCourse.id)));
      bloc.add(DueDateChanged(DueDateSelection.date(Date.parse('2023-10-12'))));
      bloc.add(const DescriptionChanged('This is a description'));
      bloc.add(const IsPrivateChanged(true));

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
            dueDate: (
              Date('2023-10-12'),
              selection: DueDateSelection.date(Date('2023-10-12')),
              lessonChipsSelectable: true,
              error: null
            ),
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

      bloc.add(const Save());

      await pumpEventQueue();

      expect(bloc.state, const SavedSuccessfully(isEditing: false));
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
      nextLessonCalculator.datesToReturn = [Date('2024-11-13')];

      bloc.add(const TitleChanged('Paint masterpiece'));
      bloc.add(CourseChanged(CourseId(artCourse.id)));
      bloc.add(DueDateChanged(DueDateSelection.date(Date.parse('2024-11-13'))));
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
            dueDate: (
              Date('2024-11-13'),
              selection: DateDueDateSelection(Date('2024-11-13')),
              lessonChipsSelectable: true,
              error: null
            ),
            submissions:
                SubmissionsEnabled(deadline: Time(hour: 16, minute: 30)),
            description: 'This is a description',
            attachments: IList(),
            notifyCourseMembers: true,
            isPrivate: (false, isChangeable: false),
            hasModifiedData: true,
            isEditing: false,
          ));

      bloc.add(const Save());

      await pumpEventQueue();

      expect(bloc.state, const SavedSuccessfully(isEditing: false));
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
      const homeworkId = HomeworkId('foo');
      final bloc = createBlocForEditingHomeworkDialog(homeworkId);

      expect(bloc.state, const LoadingHomework(homeworkId, isEditing: true));
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

    // https://github.com/SharezoneApp/sharezone-app/issues/1306
    test(
        'Regression Test: Sets submission time to null when submission is disabled',
        () async {
      final mathCourse = courseWith(id: 'maths_course');
      addCourse(mathCourse);

      final bloc = createBlocForNewHomeworkDialog();
      bloc.add(const TitleChanged('S. 32 8a)'));
      bloc.add(CourseChanged(CourseId(mathCourse.id)));
      bloc.add(DueDateChanged(DueDateSelection.date(Date.parse('2023-10-12'))));

      // Enable submissions and set a submission time.
      bloc.add(SubmissionsChanged(
          (enabled: true, submissionTime: Time(hour: 16, minute: 30))));

      await pumpEventQueue();

      // Now, disable submissions.
      bloc.add(
          const SubmissionsChanged((enabled: false, submissionTime: null)));

      await pumpEventQueue();
      bloc.add(const Save());
      await pumpEventQueue();

      expect(
        homeworkDialogApi.userInputToBeCreated.todoUntil,
        // Ensure that the submission time is reset to 00:00
        DateTime(2023, 10, 12, 0, 0),
      );
    });

    test(
        'Regression test: When choosing due date then the submission time should not reset to 00:00',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      await pumpEventQueue();
      bloc.add(DueDateChanged(DueDateSelection.date(Date('2024-03-08'))));
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
    test(
        'emits started saving uploading attachments presentation event when adding homework',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));

      bloc.add(const TitleChanged('abc'));
      bloc.add(const CourseChanged(CourseId('foo_course')));
      bloc.add(DueDateChanged(DueDateSelection.date(Date('2024-03-08'))));
      bloc.add(
          AttachmentsAdded(IList([randomLocalFileFrom(path: 'foo/bar.png')])));
      bloc.add(const Save());

      expect(bloc.presentation, emits(const StartedUploadingAttachments()));
    });
    test(
        'does not emit uploading attachments presentation event when adding homework without attachment',
        () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));

      bloc.add(const TitleChanged('abc'));
      bloc.add(const CourseChanged(CourseId('foo_course')));
      bloc.add(DueDateChanged(DueDateSelection.date(Date('2024-03-08'))));

      // Add and remove attachment just to make it a bit more "tricky"
      final file = randomLocalFileFrom(path: 'foo/bar.png');
      bloc.add(AttachmentsAdded(IList([file])));
      bloc.add(AttachmentRemoved(file.fileId));

      bloc.add(const Save());

      expect(
          bloc.presentation, neverEmits(const StartedUploadingAttachments()));

      await bloc.stream.whereType<SavedSuccessfully>().first;
      await bloc.close();
    });
    test(
        'emits started saving uploading attachments presentation event when editing homework',
        () async {
      const homeworkId = HomeworkId('foo_homework_id');
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final homework = randomHomeworkWith(
        id: homeworkId.value,
        title: 'title text',
        courseId: 'foo_course',
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await bloc.stream.whereType<Ready>().first;

      bloc.add(
          AttachmentsAdded(IList([randomLocalFileFrom(path: 'foo/bar.png')])));
      bloc.add(const Save());

      expect(bloc.presentation, emits(const StartedUploadingAttachments()));
    });
    test(
        'does not emit started saving uploading attachments presentation event when editing homework without new attachment',
        () async {
      const homeworkId = HomeworkId('foo_homework_id');
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final homework = randomHomeworkWith(
        id: homeworkId.value,
        title: 'title text',
        courseId: 'foo_course',
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await pumpEventQueue();

      // Add and remove attachment just to make it a bit more "tricky"
      final file = randomLocalFileFrom(path: 'foo/bar.png');
      bloc.add(AttachmentsAdded(IList([file])));
      bloc.add(AttachmentRemoved(file.fileId));
      bloc.add(const Save());

      expect(
          bloc.presentation, neverEmits(const StartedUploadingAttachments()));

      await bloc.stream.whereType<SavedSuccessfully>().first;
      await bloc.close();
    });
    test('Analytics is called when a homework is successfully added', () async {
      final bloc = createBlocForNewHomeworkDialog();
      addCourse(courseWith(
        id: 'foo_course',
      ));

      bloc.add(const TitleChanged('abc'));
      bloc.add(const CourseChanged(CourseId('foo_course')));
      bloc.add(DueDateChanged(DueDateSelection.date(Date('2024-03-08'))));
      bloc.add(const Save());
      await bloc.stream.whereType<SavedSuccessfully>().first;

      expect(analyticsBackend.loggedEvents, [
        {'homework_add': {}},
      ]);
    });
    test('Analytics is called when a homework is successfully edited',
        () async {
      const homeworkId = HomeworkId('foo_homework_id');
      addCourse(courseWith(
        id: 'foo_course',
      ));
      final homework = randomHomeworkWith(
        id: homeworkId.value,
        title: 'title text',
        courseId: 'foo_course',
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc = createBlocForEditingHomeworkDialog(homeworkId);
      await pumpEventQueue();

      bloc.add(const TitleChanged('new title'));
      bloc.add(const Save());
      await bloc.stream.whereType<SavedSuccessfully>().first;

      expect(analyticsBackend.loggedEvents, [
        {'homework_edit': {}},
      ]);
    });
    test('Sucessfully displays and edits existing homework', () async {
      const homeworkId = HomeworkId('foo_homework_id');

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
        id: homeworkId.value,
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

      bloc.add(const AttachmentRemoved(FileId('foo_attachment_id1')));

      await pumpEventQueue();
      expect(
        bloc.state,
        Ready(
          title: ('title text', error: null),
          course: const CourseChosen(
            courseId: CourseId('foo_course'),
            courseName: 'Foo course',
            isChangeable: false,
          ),
          dueDate: (
            Date('2024-03-12'),
            selection: null,
            lessonChipsSelectable: true,
            error: null,
          ),
          submissions: const SubmissionsDisabled(isChangeable: false),
          description: 'description text',
          attachments: IList([
            FileView(
                fileId: const FileId('foo_attachment_id2'),
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

      bloc.add(const Save());
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
      expect(bloc.state, const SavedSuccessfully(isEditing: true));
    });
    test('Sucessfully displays and edits existing homework 2', () async {
      const homeworkId = HomeworkId('bar_homework_id');

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
        id: homeworkId.value,
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
          course: const CourseChosen(
            courseId: CourseId('bar_course'),
            courseName: 'Bar course',
            isChangeable: false,
          ),
          dueDate: (
            Date('2024-03-12'),
            selection: null,
            lessonChipsSelectable: true,
            error: null,
          ),
          submissions: SubmissionsEnabled(deadline: Time(hour: 16, minute: 35)),
          description: 'description text',
          attachments: IList(),
          notifyCourseMembers: false,
          isPrivate: (false, isChangeable: false),
          hasModifiedData: false,
          isEditing: true,
        ),
      );

      bloc.add(const Save());
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

      expect(bloc.state, const SavedSuccessfully(isEditing: true));
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
      mimeType: mimeType,
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
