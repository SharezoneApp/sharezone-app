// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';

enum HomeworkParameter { id, subject, title, done, date }

void main() {
  group('Homework', () {
    test('is overdue when the todoDate is before now', () {
      final h =
          createHomework(todoDate: const Date(year: 2019, month: 02, day: 03));
      const today = Date(year: 2019, month: 02, day: 18);
      expect(h.isOverdueRelativeTo(today), true);
    });
    test('is not overdue when the todoDate equals the day given', () {
      var date = const Date(year: 2019, month: 02, day: 03);
      final h = createHomework(todoDate: date);
      expect(h.isOverdueRelativeTo(date), false);
    });

    test('is not overdue when the todoDate is after the day given', () {
      final h =
          createHomework(todoDate: const Date(year: 2019, month: 02, day: 03));
      const today = Date(year: 2019, month: 01, day: 02);
      expect(h.isOverdueRelativeTo(today), false);
    });
  });
}

void expectThrowsArgumentError(Function f) {
  expect(() => f(), throwsArgumentError);
}
