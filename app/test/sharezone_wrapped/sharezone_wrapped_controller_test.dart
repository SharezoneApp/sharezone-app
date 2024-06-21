import 'dart:math';

import 'package:analytics/analytics.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_controller.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_repository.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:time/time.dart';

import 'sharezone_wrapped_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharezoneWrappedRepository>(),
  MockSpec<CrashAnalytics>(),
  MockSpec<Analytics>(),
])
void main() {
  late MockSharezoneWrappedRepository repository;
  late MockCrashAnalytics crashAnalytics;
  late MockAnalytics analytics;
  late SharezoneWrappedController controller;

  late Course math;
  late Course english;
  late Course history;
  late Course biology;
  late Course physics;

  late List<Course> courses;

  late Random random;

  Course generateCourse({GroupId? groupId, String? name}) {
    return Course.create().copyWith(
      id: '$groupId',
      name: name,
    );
  }

  Lesson generateLesson({
    required GroupId groupId,
    required Time startTime,
    required Time endTime,
    required Date date,
    required WeekDay weekday,
    required WeekType weekType,
  }) {
    return Lesson(
      createdOn: DateTime(2024, 1, 1),
      startTime: startTime,
      endTime: endTime,
      startDate: date,
      endDate: date,
      groupID: groupId.value,
      groupType: GroupType.course,
      lessonID: Id.generate(random: random).value,
      weekday: weekday,
      place: null,
      teacher: null,
      weektype: weekType,
      periodNumber: null,
      substitutions: {},
    );
  }

  setUp(() {
    repository = MockSharezoneWrappedRepository();
    crashAnalytics = MockCrashAnalytics();
    analytics = MockAnalytics();
    controller = SharezoneWrappedController(
      repository: repository,
      crashAnalytics: crashAnalytics,
      analytics: analytics,
    );

    random = Random(42);

    math = generateCourse(groupId: const GroupId('1'), name: 'Math');
    english = generateCourse(groupId: const GroupId('2'), name: 'English');
    history = generateCourse(groupId: const GroupId('3'), name: 'History');
    biology = generateCourse(groupId: const GroupId('4'), name: 'Biology');
    physics = generateCourse(groupId: const GroupId('5'), name: 'Physics');

    courses = [math, english, history, biology, physics];
  });

  group(SharezoneWrappedController, () {
    test('calculates the top three lesson courses', () async {
      when(repository.getCourses()).thenAnswer((_) => courses);
      when(repository.getLessons()).thenAnswer(
        (_) async => [
          for (var i = 0; i < 5; i++)
            generateLesson(
              groupId: CourseId(math.id),
              startTime: Time(hour: 8 + i, minute: 0),
              endTime: Time(hour: 9 + i, minute: 0),
              date: Date('2024-01-01'),
              weekday: WeekDay.monday,
              weekType: WeekType.always,
            ),
          for (var i = 0; i < 3; i++)
            generateLesson(
              groupId: CourseId(biology.id),
              startTime: Time(hour: 8 + i, minute: 0),
              endTime: Time(hour: 9 + i, minute: 0),
              date: Date('2024-01-01'),
              weekday: WeekDay.monday,
              weekType: WeekType.always,
            ),
          for (var i = 0; i < 6; i++)
            generateLesson(
              groupId: CourseId(physics.id),
              startTime: Time(hour: 8 + i, minute: 0),
              endTime: Time(hour: 9 + i, minute: 0),
              date: Date('2024-01-01'),
              weekday: WeekDay.monday,
              weekType: WeekType.always,
            ),
          for (var i = 0; i < 2; i++)
            generateLesson(
              groupId: CourseId(history.id),
              startTime: Time(hour: 8 + i, minute: 0),
              endTime: Time(hour: 9 + i, minute: 0),
              date: Date('2024-01-01'),
              weekday: WeekDay.monday,
              weekType: WeekType.always,
            ),
        ],
      );

      final values = await controller.getValues();

      // See comment in implementation for explanation
      const schoolWeeksPerYear = 40;

      const mathHours = 5 * schoolWeeksPerYear;
      const biologyHours = 3 * schoolWeeksPerYear;
      const physicsHours = 6 * schoolWeeksPerYear;

      expect(values.amountOfLessonHoursTopThreeCourses, [
        (CourseId(physics.id), physics.name, physicsHours),
        (CourseId(math.id), math.name, mathHours),
        (CourseId(biology.id), biology.name, biologyHours),
      ]);
    });

    test('calculates total amount of lessons', () async {
      when(repository.getCourses()).thenAnswer((_) => courses);
      when(repository.getLessons()).thenAnswer(
        (_) async => [
          for (final course in courses)
            for (var i = 0; i < 5; i++)
              generateLesson(
                groupId: CourseId(course.id),
                startTime: Time(hour: 8 + i, minute: 0),
                endTime: Time(hour: 9 + i, minute: 0),
                date: Date('2024-01-01'),
                weekday: WeekDay.monday,
                weekType: WeekType.always,
              ),
          generateLesson(
            groupId: CourseId(math.id),
            startTime: Time(hour: 7, minute: 0),
            endTime: Time(hour: 8, minute: 0),
            date: Date('2024-01-01'),
            weekday: WeekDay.monday,
            weekType: WeekType.a,
          ),
        ],
      );

      final values = await controller.getValues();

      // See comment in implementation for explanation
      const schoolWeeksPerYear = 40;

      // Every course has 5 lessons per week
      const hoursPerCourse = 5 * schoolWeeksPerYear;

      // We have one course that only has lessons every second week
      const abWeekHours = 1 * (schoolWeeksPerYear / 2);

      const totalHours = (hoursPerCourse * 5) + abWeekHours;

      expect(values.totalAmountOfLessonHours, totalHours.toInt());
    });

    test('calculates the top three homework courses', () async {
      when(repository.getCourses()).thenAnswer((_) => courses);
      when(repository.getAmountOfHomeworksFor(courseId: CourseId(english.id)))
          .thenAnswer((_) async => 20);
      when(repository.getAmountOfHomeworksFor(courseId: CourseId(math.id)))
          .thenAnswer((_) async => 10);
      when(repository.getAmountOfHomeworksFor(courseId: CourseId(history.id)))
          .thenAnswer((_) async => 30);
      when(repository.getAmountOfHomeworksFor(courseId: CourseId(physics.id)))
          .thenAnswer((_) async => 50);
      when(repository.getAmountOfHomeworksFor(courseId: CourseId(biology.id)))
          .thenAnswer((_) async => 40);

      final values = await controller.getValues();
      expect(values.amountOfHomeworksTopThreeCourses, [
        (CourseId(physics.id), physics.name, 50),
        (CourseId(biology.id), biology.name, 40),
        (CourseId(history.id), history.name, 30),
      ]);
    });

    test('calculates the top three exam courses', () async {
      when(repository.getCourses()).thenAnswer((_) => courses);
      when(repository.getAmountOfExamsFor(courseId: CourseId(english.id)))
          .thenAnswer((_) async => 20);
      when(repository.getAmountOfExamsFor(courseId: CourseId(math.id)))
          .thenAnswer((_) async => 10);
      when(repository.getAmountOfExamsFor(courseId: CourseId(history.id)))
          .thenAnswer((_) async => 30);
      when(repository.getAmountOfExamsFor(courseId: CourseId(physics.id)))
          .thenAnswer((_) async => 50);
      when(repository.getAmountOfExamsFor(courseId: CourseId(biology.id)))
          .thenAnswer((_) async => 40);

      final values = await controller.getValues();
      expect(values.amountOfExamsTopThreeCourses, [
        (CourseId(physics.id), physics.name, 50),
        (CourseId(biology.id), biology.name, 40),
        (CourseId(history.id), history.name, 30),
      ]);
    });

    test('fetches total amount of exams', () async {
      when(repository.getTotalAmountOfExams()).thenAnswer((_) async => 42);

      final values = await controller.getValues();
      expect(values.totalAmountOfExams, 42);
    });

    test('fetches total amount of homeworks correct', () async {
      when(repository.getTotalAmountOfHomeworks()).thenAnswer((_) async => 42);

      final values = await controller.getValues();
      expect(values.totalAmountOfHomeworks, 42);
    });

    test('log analytics when wrapped generated', () async {
      await controller.getValues();

      verify(analytics.log(NamedAnalyticsEvent(name: 'sz_wrapped_generated')));
    });
  });
}
