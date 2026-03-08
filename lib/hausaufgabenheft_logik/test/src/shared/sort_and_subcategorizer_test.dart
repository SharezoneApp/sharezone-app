// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/shared/color.dart';
import 'package:hausaufgabenheft_logik/src/shared/sort_and_subcategorizer.dart';

class _TestHomework extends BaseHomeworkReadModel {
  const _TestHomework({
    required super.id,
    required super.title,
    required super.subject,
    required super.courseId,
    required super.withSubmissions,
    required super.todoDate,
  });
}

void main() {
  group('HomeworkSortAndSubcategorizer', () {
    late HomeworkSortAndSubcategorizer subcategorizer;
    const today = Date(year: 2023, month: 10, day: 15); // A Sunday

    setUp(() {
      subcategorizer = HomeworkSortAndSubcategorizer(
        getCurrentDate: () => today,
      );
    });

    final mathSubject = Subject('Math', abbreviation: 'M', color: const Color(0xFF000000));
    final englishSubject = Subject('English', abbreviation: 'E', color: const Color(0xFF000000));

    final overdueHomework = _TestHomework(
      id: const HomeworkId('hw-overdue'),
      title: const Title('Overdue HW'),
      subject: mathSubject,
      courseId: const CourseId('c-1'),
      withSubmissions: false,
      todoDate: DateTime(2023, 10, 14), // Yesterday
    );

    final todayHomework = _TestHomework(
      id: const HomeworkId('hw-today'),
      title: const Title('Today HW'),
      subject: englishSubject,
      courseId: const CourseId('c-1'),
      withSubmissions: false,
      todoDate: DateTime(2023, 10, 15), // Today
    );

    final tomorrowHomework = _TestHomework(
      id: const HomeworkId('hw-tomorrow'),
      title: const Title('Tomorrow HW'),
      subject: mathSubject,
      courseId: const CourseId('c-1'),
      withSubmissions: false,
      todoDate: DateTime(2023, 10, 16), // Tomorrow
    );

    final in2DaysHomework = _TestHomework(
      id: const HomeworkId('hw-in2days'),
      title: const Title('In 2 Days HW'),
      subject: englishSubject,
      courseId: const CourseId('c-1'),
      withSubmissions: false,
      todoDate: DateTime(2023, 10, 17), // In 2 days
    );

    final futureHomework = _TestHomework(
      id: const HomeworkId('hw-future'),
      title: const Title('Future HW'),
      subject: mathSubject,
      courseId: const CourseId('c-1'),
      withSubmissions: false,
      todoDate: DateTime(2023, 10, 18), // Future
    );

    final homeworks = <BaseHomeworkReadModel>[
      futureHomework,
      tomorrowHomework,
      todayHomework,
      overdueHomework,
      in2DaysHomework,
    ].toIList();

    test('sortAndSubcategorize SmallestDateSubjectAndTitleSort', () {
      final result = subcategorizer.sortAndSubcategorize(
        homeworks,
        SmallestDateSubjectAndTitleSort(),
      );

      expect(result.length, 5);

      expect(result[0].dateSection, equals(HomeworkDateSection.overdue));
      expect(result[0].homeworks.single, overdueHomework);

      expect(result[1].dateSection, equals(HomeworkDateSection.today));
      expect(result[1].homeworks.single, todayHomework);

      expect(result[2].dateSection, equals(HomeworkDateSection.tomorrow));
      expect(result[2].homeworks.single, tomorrowHomework);

      expect(result[3].dateSection, equals(HomeworkDateSection.dayAfterTomorrow));
      expect(result[3].homeworks.single, in2DaysHomework);

      expect(result[4].dateSection, equals(HomeworkDateSection.later));
      expect(result[4].homeworks.single, futureHomework);
    });

    test('sortAndSubcategorize SubjectSmallestDateAndTitleSort', () {
      final result = subcategorizer.sortAndSubcategorize(
        homeworks,
        SubjectSmallestDateAndTitleSort(),
      );

      expect(result.length, 2); // Math and English

      final englishSection = result.firstWhere((s) => s.title == 'English');
      expect(englishSection.homeworks.length, 2);
      expect(englishSection.homeworks.contains(todayHomework), isTrue);
      expect(englishSection.homeworks.contains(in2DaysHomework), isTrue);

      final mathSection = result.firstWhere((s) => s.title == 'Math');
      expect(mathSection.homeworks.length, 3);
      expect(mathSection.homeworks.contains(overdueHomework), isTrue);
      expect(mathSection.homeworks.contains(tomorrowHomework), isTrue);
      expect(mathSection.homeworks.contains(futureHomework), isTrue);
    });

    test('sortAndSubcategorize WeekdayDateSubjectAndTitleSort', () {
      final result = subcategorizer.sortAndSubcategorize(
        homeworks,
        WeekdayDateSubjectAndTitleSort(),
      );

      // 14th = Sat (6), 15th = Sun (7), 16th = Mon (1), 17th = Tue (2), 18th = Wed (3)
      expect(result.length, 5);

      final mondaySection = result.firstWhere((s) => s.weekday == 1);
      expect(mondaySection.homeworks.single, tomorrowHomework); // 16th

      final tuesdaySection = result.firstWhere((s) => s.weekday == 2);
      expect(tuesdaySection.homeworks.single, in2DaysHomework); // 17th

      final wednesdaySection = result.firstWhere((s) => s.weekday == 3);
      expect(wednesdaySection.homeworks.single, futureHomework); // 18th

      final saturdaySection = result.firstWhere((s) => s.weekday == 6);
      expect(saturdaySection.homeworks.single, overdueHomework); // 14th

      final sundaySection = result.firstWhere((s) => s.weekday == 7);
      expect(sundaySection.homeworks.single, todayHomework); // 15th
    });
  });
}
