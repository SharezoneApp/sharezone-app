import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:files_basics/files_models.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/blocs/homework/new_homework_dialog_bloc.dart';

import '../analytics/analytics_test.dart';
import 'homework_dialog_test.dart';
import 'homework_dialog_test.mocks.dart';

void main() {
  group('HomeworkDialogBloc', () {
    late MockSharezoneGateway sharezoneGateway;
    late MockCourseGateway courseGateway;
    late MockHomeworkDialogApi homeworkDialogApi;
    late MockNextLessonCalculator nextLessonCalculator;
    late MockSharezoneContext sharezoneContext;
    late LocalAnalyticsBackend analyticsBackend;
    late Analytics analytics;

    setUp(() {
      courseGateway = MockCourseGateway();
      sharezoneGateway = MockSharezoneGateway();
      homeworkDialogApi = MockHomeworkDialogApi();
      nextLessonCalculator = MockNextLessonCalculator();
      sharezoneContext = MockSharezoneContext();
      analyticsBackend = LocalAnalyticsBackend();
      analytics = Analytics(analyticsBackend);
    });

    test('Returns empty dialog when called for creating a new homework', () {
      final bloc = NewHomeworkDialogBloc(
        api: MockHomeworkDialogApi(),
      );
      expect(bloc.state, emptyDialog);
    });
    test('Returns loading state when called for an existing homework', () {
      final homeworkId = HomeworkId('foo');

      final homeworkDialogApi = MockHomeworkDialogApi();
      homeworkDialogApi.homeworkToReturn =
          HomeworkDto.create(courseID: 'courseID');
      final bloc =
          NewHomeworkDialogBloc(api: homeworkDialogApi, homeworkId: homeworkId);
      expect(bloc.state, LoadingHomework(homeworkId, isEditing: true));
    });
    test('Returns homework data when called for existing homework', () async {
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
        private: false,
      );
      homeworkDialogApi.homeworkToReturn = homework;

      final bloc =
          NewHomeworkDialogBloc(api: homeworkDialogApi, homeworkId: homeworkId);
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
          dueDate: DateTime(2024, 03, 12),
          submissions: const SubmissionsDisabled(isChangeable: true),
          description: 'description text',
          attachments: IList([
            FileView(
              fileId: FileId('foo_attachment_id1'),
              fileName: 'foo_attachment1.png',
              format: FileFormat.image,
            ),
            FileView(
              fileId: FileId('foo_attachment_id2'),
              fileName: 'foo_attachment2.pdf',
              format: FileFormat.pdf,
            ),
          ]),
          notifyCourseMembers: false,
          isPrivate: (false, isChangeable: false),
          hasModifiedData: false,
          isEditing: true,
        ),
      );
    });
  });
}