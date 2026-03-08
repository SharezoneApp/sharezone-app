// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/homework.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/date.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/subject.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/title.dart';
import 'package:hausaufgabenheft_logik/src/shared/color.dart';

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
  group('BaseHomeworkReadModel', () {
    const today = Date(year: 2023, month: 10, day: 15);
    final subject = Subject(
      'Math',
      abbreviation: 'M',
      color: const Color(0xFF000000),
    );
    const title = Title('Homework 1');

    test('isOverdueRelativeTo returns true if todoDate is before today', () {
      final pastDate = DateTime(2023, 10, 14);
      final homework = _TestHomework(
        id: const HomeworkId('hw-1'),
        title: title,
        subject: subject,
        courseId: const CourseId('course-1'),
        withSubmissions: false,
        todoDate: pastDate,
      );

      expect(homework.isOverdueRelativeTo(today), isTrue);
    });

    test('isOverdueRelativeTo returns false if todoDate is exactly today', () {
      final currentDate = DateTime(2023, 10, 15, 12, 0); // time shouldn't matter
      final homework = _TestHomework(
        id: const HomeworkId('hw-1'),
        title: title,
        subject: subject,
        courseId: const CourseId('course-1'),
        withSubmissions: false,
        todoDate: currentDate,
      );

      expect(homework.isOverdueRelativeTo(today), isFalse);
    });

    test('isOverdueRelativeTo returns false if todoDate is after today', () {
      final futureDate = DateTime(2023, 10, 16);
      final homework = _TestHomework(
        id: const HomeworkId('hw-1'),
        title: title,
        subject: subject,
        courseId: const CourseId('course-1'),
        withSubmissions: false,
        todoDate: futureDate,
      );

      expect(homework.isOverdueRelativeTo(today), isFalse);
    });
  });
}
