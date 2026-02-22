// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
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
    late HomeworkSortAndSubcategorizer<StudentHomeworkReadModel> subcategorizer;
    // Oct 10, 2023 is a Tuesday
    final now = const Date(year: 2023, month: 10, day: 10);

    setUp(() {
      subcategorizer = HomeworkSortAndSubcategorizer(getCurrentDate: () => now);
    });

    group('SmallestDateSubjectAndTitleSort', () {
      final sort = SmallestDateSubjectAndTitleSort(getCurrentDate: () => now);

      test('categorizes homework correctly into sections', () {
        final overdue = createHomework(
          todoDate: now.addDays(-1),
          title: 'Overdue',
        );
        final today = createHomework(todoDate: now, title: 'Today');
        final tomorrow = createHomework(
          todoDate: now.addDays(1),
          title: 'Tomorrow',
        );
        final in2Days = createHomework(
          todoDate: now.addDays(2),
          title: 'In 2 Days',
        );
        final future = createHomework(
          todoDate: now.addDays(3),
          title: 'Future',
        );

        final homeworks = [future, in2Days, tomorrow, today, overdue].toIList();

        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 5);
        expect(sections[0].type, HomeworkSectionType.date);
        expect(sections[0].dateSection, HomeworkDateSection.overdue);
        expect(sections[0].homeworks.first.title.value, 'Overdue');

        expect(sections[1].dateSection, HomeworkDateSection.today);
        expect(sections[1].homeworks.first.title.value, 'Today');

        expect(sections[2].dateSection, HomeworkDateSection.tomorrow);
        expect(sections[2].homeworks.first.title.value, 'Tomorrow');

        expect(sections[3].dateSection, HomeworkDateSection.dayAfterTomorrow);
        expect(sections[3].homeworks.first.title.value, 'In 2 Days');

        expect(sections[4].dateSection, HomeworkDateSection.later);
        expect(sections[4].homeworks.first.title.value, 'Future');
      });

      test('sorts within sections by subject then title', () {
        final h1 = createHomework(
          todoDate: now,
          subject: 'B',
          title: 'A',
          id: '1',
        );
        final h2 = createHomework(
          todoDate: now,
          subject: 'A',
          title: 'B',
          id: '2',
        );
        final h3 = createHomework(
          todoDate: now,
          subject: 'A',
          title: 'A',
          id: '3',
        );

        final homeworks = [h1, h2, h3].toIList();
        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 1);
        final sorted = sections.first.homeworks;
        expect(sorted[0].id.toString(), '3'); // A - A
        expect(sorted[1].id.toString(), '2'); // A - B
        expect(sorted[2].id.toString(), '1'); // B - A
      });

      test('omits empty sections', () {
        final today = createHomework(todoDate: now, title: 'Today');
        final homeworks = [today].toIList();

        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 1);
        expect(sections.first.dateSection, HomeworkDateSection.today);
      });
    });

    group('SubjectSmallestDateAndTitleSort', () {
      final sort = SubjectSmallestDateAndTitleSort();

      test('categorizes by subject', () {
        final math = createHomework(subject: 'Math', title: '1');
        final english = createHomework(subject: 'English', title: '2');

        final homeworks = [math, english].toIList();
        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 2);
        // Sorted alphabetically by subject name
        expect(sections[0].type, HomeworkSectionType.subject);
        expect(sections[0].title, 'English');
        expect(sections[1].title, 'Math');
      });

      test('sorts within subject by date then title', () {
        final h1 = createHomework(
          subject: 'Math',
          todoDate: now.addDays(1),
          title: 'B',
          id: '1',
        );
        final h2 = createHomework(
          subject: 'Math',
          todoDate: now,
          title: 'A',
          id: '2',
        );
        final h3 = createHomework(
          subject: 'Math',
          todoDate: now,
          title: 'B',
          id: '3',
        );

        final homeworks = [h1, h2, h3].toIList();
        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 1);
        final sorted = sections.first.homeworks;
        expect(sorted[0].id.toString(), '2'); // Today, A
        expect(sorted[1].id.toString(), '3'); // Today, B
        expect(sorted[2].id.toString(), '1'); // Tomorrow, B
      });
    });

    group('WeekdayDateSubjectAndTitleSort', () {
      final sort = WeekdayDateSubjectAndTitleSort();

      test('categorizes by weekday', () {
        // Oct 10, 2023 is Tuesday
        final tuesday = createHomework(todoDate: now, title: 'Tue');
        final wednesday = createHomework(
          todoDate: now.addDays(1),
          title: 'Wed',
        );

        final homeworks = [tuesday, wednesday].toIList();
        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 2);
        // Tuesday is 2, Wednesday is 3
        expect(sections[0].type, HomeworkSectionType.weekday);
        expect(sections[0].weekday, 2);
        expect(sections[1].weekday, 3);
      });

      test('groups different dates with same weekday together', () {
        // Oct 10 (Tue) and Oct 17 (Tue)
        final tue1 = createHomework(todoDate: now, title: 'Tue1', id: '1');
        final tue2 = createHomework(
          todoDate: now.addDays(7),
          title: 'Tue2',
          id: '2',
        );

        final homeworks = [tue2, tue1].toIList();
        final sections = subcategorizer.sortAndSubcategorize(homeworks, sort);

        expect(sections.length, 1);
        expect(sections.first.weekday, 2);
        expect(sections.first.homeworks.length, 2);
        // Should be sorted by date
        expect(sections.first.homeworks[0].id.toString(), '1');
        expect(sections.first.homeworks[1].id.toString(), '2');
      });
    });
  });
}
