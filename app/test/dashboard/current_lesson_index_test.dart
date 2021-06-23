import 'package:sharezone/dashboard/bloc/dashboard_bloc.dart';
import 'package:sharezone/dashboard/timetable/lesson_view.dart';
import 'package:test/test.dart';

void main() {
  LessonView getLessonViewWithTimeStatus(LessonTimeStatus timeline) {
    return LessonView(
      start: "8:00",
      end: "9:00",
      room: "100",
      abbreviation: "D",
      design: null,
      lesson: null,
      timeStatus: timeline,
      percentTimePassed: null,
      periodNumber: null,
    );
  }

  group('validate getCurrentLessonIndex()', () {
    test('school has not started yet', () {
      final onlyYetToComeViews = [
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(onlyYetToComeViews), 0);
    });

    test('school is over', () {
      final schoolIsOver = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
      ];
      expect(() => getCurrentLessonIndex(schoolIsOver),
          throwsA(predicate((e) => e is AllLessonsAreOver)));
    });

    test('first lesson is now', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 0);
    });

    test('first lesson is now', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 0);
    });

    test('second lesson is now', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.isNow),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 1);
    });

    test('free lesson / break now, so pick the next lesson', () {
      final firstLessonNow = [
        getLessonViewWithTimeStatus(LessonTimeStatus.hasAlreadyTakenPlace),
        getLessonViewWithTimeStatus(LessonTimeStatus.isYetToCome),
      ];
      expect(getCurrentLessonIndex(firstLessonNow), 1);
    });
  });
}
