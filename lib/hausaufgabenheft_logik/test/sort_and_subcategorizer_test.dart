// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/shared/sort_and_subcategorizer.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';

void main() {
  group('HomeworkSortAndSubcategorizer', () {
    late HomeworkSortAndSubcategorizer<StudentHomeworkReadModel> sorter;
    const now = Date(year: 2023, month: 10, day: 25);

    setUp(() {
      sorter = HomeworkSortAndSubcategorizer(getCurrentDate: () => now);
    });

    test('SmallestDateSubjectAndTitleSort buckets correctly', () {
      final overdue = createHomework(
        title: 'Overdue',
        todoDate: const Date(year: 2023, month: 10, day: 24),
      );
      final today = createHomework(title: 'Today', todoDate: now);
      final tomorrow = createHomework(
        title: 'Tomorrow',
        todoDate: const Date(year: 2023, month: 10, day: 26),
      );
      final dayAfterTomorrow = createHomework(
        title: 'In 2 Days',
        todoDate: const Date(year: 2023, month: 10, day: 27),
      );
      final future = createHomework(
        title: 'Future',
        todoDate: const Date(year: 2023, month: 10, day: 28),
      );

      final list =
          [future, dayAfterTomorrow, tomorrow, today, overdue].toIList();

      final result = sorter.sortAndSubcategorize(
        list,
        SmallestDateSubjectAndTitleSort(getCurrentDate: () => now),
      );

      expect(result.length, 5);
      expect(result[0].dateSection, HomeworkDateSection.overdue);
      expect(result[0].homeworks.single.title, const Title('Overdue'));

      expect(result[1].dateSection, HomeworkDateSection.today);
      expect(result[1].homeworks.single.title, const Title('Today'));

      expect(result[2].dateSection, HomeworkDateSection.tomorrow);
      expect(result[2].homeworks.single.title, const Title('Tomorrow'));

      expect(result[3].dateSection, HomeworkDateSection.dayAfterTomorrow);
      expect(result[3].homeworks.single.title, const Title('In 2 Days'));

      expect(result[4].dateSection, HomeworkDateSection.later);
      expect(result[4].homeworks.single.title, const Title('Future'));
    });

    test('SmallestDateSubjectAndTitleSort handles empty list', () {
      final result = sorter.sortAndSubcategorize(
        IList(),
        SmallestDateSubjectAndTitleSort(getCurrentDate: () => now),
      );
      expect(result, isEmpty);
    });

    test('SubjectSmallestDateAndTitleSort groups by subject', () {
      final math1 = createHomework(
        title: 'Math 1',
        subject: 'Math',
        todoDate: now,
      );
      final math2 = createHomework(
        title: 'Math 2',
        subject: 'Math',
        todoDate: now.addDays(1),
      );
      final bio = createHomework(
        title: 'Bio',
        subject: 'Biology',
        todoDate: now,
      );

      final list = [math2, bio, math1].toIList();

      final result = sorter.sortAndSubcategorize(
        list,
        SubjectSmallestDateAndTitleSort(),
      );

      // Expected order: Biology, Math
      expect(result.length, 2);

      expect(result[0].title, 'Biology');
      expect(result[0].homeworks.length, 1);
      expect(result[0].homeworks[0].title, const Title('Bio'));

      expect(result[1].title, 'Math');
      expect(result[1].homeworks.length, 2);
      // Within subject, sorted by date (math1 is today, math2 is tomorrow)
      expect(result[1].homeworks[0].title, const Title('Math 1'));
      expect(result[1].homeworks[1].title, const Title('Math 2'));
    });

    test('WeekdayDateSubjectAndTitleSort groups by weekday', () {
      // 2023-10-25 is Wednesday (3)
      final wed = createHomework(
        title: 'Wed',
        todoDate: const Date(year: 2023, month: 10, day: 25),
      );
      final thu = createHomework(
        title: 'Thu',
        todoDate: const Date(year: 2023, month: 10, day: 26),
      );
      final mon = createHomework(
        title: 'Mon',
        todoDate: const Date(year: 2023, month: 10, day: 23),
      ); // Previous Monday

      final list = [thu, wed, mon].toIList();

      final result = sorter.sortAndSubcategorize(
        list,
        WeekdayDateSubjectAndTitleSort(),
      );

      // Order: Monday (1), Wednesday (3), Thursday (4)
      expect(result.length, 3);

      expect(result[0].weekday, 1);
      expect(result[0].homeworks.single.title, const Title('Mon'));

      expect(result[1].weekday, 3);
      expect(result[1].homeworks.single.title, const Title('Wed'));

      expect(result[2].weekday, 4);
      expect(result[2].homeworks.single.title, const Title('Thu'));
    });

    test('Sorting within sections works correctly', () {
      final h1 = createHomework(title: 'B', todoDate: now);
      final h2 = createHomework(title: 'A', todoDate: now);

      final list = [h1, h2].toIList();

      final result = sorter.sortAndSubcategorize(
        list,
        SmallestDateSubjectAndTitleSort(getCurrentDate: () => now),
      );

      expect(result.length, 1);
      expect(result[0].dateSection, HomeworkDateSection.today);
      // Same date and subject (default), sort by title
      expect(result[0].homeworks[0].title, const Title('A'));
      expect(result[0].homeworks[1].title, const Title('B'));
    });
  });
}
