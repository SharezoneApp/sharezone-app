import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/submissions/submission_permissions.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:user/user.dart';

@GenerateNiceMocks([MockSpec<CourseGateway>()])
import 'submission_permissions_test.mocks.dart';

void main() {
  late MockCourseGateway mockCourseGateway;

  setUp(() {
    mockCourseGateway = MockCourseGateway();
  });

  group('SubmissionPermissions.isAllowedToViewSubmittedPermissions', () {
    test('should allow when user is teacher and is admin in course', () async {
      when(mockCourseGateway.getRoleFromCourseNoSync(any))
          .thenReturn(MemberRole.admin);
      final stream = Stream.value(TypeOfUser.teacher);
      final permissions = SubmissionPermissions(stream, mockCourseGateway);
      final homework = HomeworkDto.create(courseID: 'course1');

      final result =
          await permissions.isAllowedToViewSubmittedPermissions(homework);

      expect(result, isTrue);
    });

    test('should allow when user is teacher and is owner in course', () async {
      when(mockCourseGateway.getRoleFromCourseNoSync(any))
          .thenReturn(MemberRole.owner);
      final stream = Stream.value(TypeOfUser.teacher);
      final permissions = SubmissionPermissions(stream, mockCourseGateway);
      final homework = HomeworkDto.create(courseID: 'course1');

      final result =
          await permissions.isAllowedToViewSubmittedPermissions(homework);

      expect(result, isTrue);
    });

    test('should deny when user is teacher but only standard in course', () async {
      when(mockCourseGateway.getRoleFromCourseNoSync(any))
          .thenReturn(MemberRole.standard);
      final stream = Stream.value(TypeOfUser.teacher);
      final permissions = SubmissionPermissions(stream, mockCourseGateway);
      final homework = HomeworkDto.create(courseID: 'course1');

      final result =
          await permissions.isAllowedToViewSubmittedPermissions(homework);

      expect(result, isFalse);
    });

    test('should deny when user is student even if admin in course', () async {
      when(mockCourseGateway.getRoleFromCourseNoSync(any))
          .thenReturn(MemberRole.admin);
      final stream = Stream.value(TypeOfUser.student);
      final permissions = SubmissionPermissions(stream, mockCourseGateway);
      final homework = HomeworkDto.create(courseID: 'course1');

      final result =
          await permissions.isAllowedToViewSubmittedPermissions(homework);

      expect(result, isFalse);
    });

    test('should deny when course role is null (defaults to standard)', () async {
      when(mockCourseGateway.getRoleFromCourseNoSync(any)).thenReturn(null);
      final stream = Stream.value(TypeOfUser.teacher);
      final permissions = SubmissionPermissions(stream, mockCourseGateway);
      final homework = HomeworkDto.create(courseID: 'course1');

      final result =
          await permissions.isAllowedToViewSubmittedPermissions(homework);

      expect(result, isFalse);
    });
  });
}
