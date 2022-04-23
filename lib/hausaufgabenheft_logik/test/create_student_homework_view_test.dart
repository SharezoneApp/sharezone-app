// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework_completion_status.dart';
import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/views/homework_view.dart';
import 'package:test/test.dart';

import 'create_homework_util.dart';

void main() {
  group('StudentViewFactory', () {
    StudentHomeworkViewFactory viewFactory;
    const defaultColor = Color.fromRGBO(255, 255, 255, 1);
    const currentDate = Date(year: 2018, month: 12, day: 03);

    setUp(() {
      viewFactory = StudentHomeworkViewFactory(
          defaultColorValue: defaultColor.value,
          getCurrentDate: () => currentDate);
    });

    test('Create Student homework View test', () {
      final white = Color.fromRGBO(255, 255, 255, 1);

      final homework = HomeworkReadModel(
        id: HomeworkId('Id'),
        status: CompletionStatus.open,
        todoDate: Date(year: 2019, month: 1, day: 28).asDateTime(),
        subject: Subject('Mathematik', color: white),
        withSubmissions: false,
        title: Title('S. 35 6a) und 8c)'),
      );
      final expectedView = StudentHomeworkView(
        id: 'Id',
        abbreviation: 'Ma',
        isCompleted: false,
        colorDate: false,
        subjectColor: white,
        subject: 'Mathematik',
        todoDate: '28. Januar 2019',
        withSubmissions: false,
        title: 'S. 35 6a) und 8c)',
      );

      final view = viewFactory.createFrom(homework);

      expect(view, equals(expectedView));
    });

    test(
        'Uses the given default color as a fallback when the homework has no color for the subject',
        () {
      final hw = createHomework(subjectColor: null);

      final view = viewFactory.createFrom(hw);

      expect(view.subjectColor, defaultColor);
    });

    test('subject is subject.name', () {
      final hw = createHomework(
          subject: 'Mathe', todoDate: Date(year: 2018, month: 12, day: 03));

      final view = viewFactory.createFrom(hw);

      expect(view.subject, 'Mathe');
    });

    test('formates date correct', () {
      final hw = createHomework(todoDate: Date(year: 2018, month: 12, day: 03));

      final view = viewFactory.createFrom(hw);

      expect(view.todoDate, '3. Dezember 2018');
    });

    test(
        'date should get colored if the homework is overdue, today or tomorrow',
        () {
      final overdue =
          createHomework(todoDate: Date(year: 2016, month: 02, day: 01));
      final today = createHomework(todoDate: currentDate);
      final tomorrow = createHomework(todoDate: currentDate.addDays(1));

      final overdueView = viewFactory.createFrom(overdue);
      final todayView = viewFactory.createFrom(today);
      final tomorrowView = viewFactory.createFrom(tomorrow);

      expect(overdueView.colorDate, true);
      expect(todayView.colorDate, true);
      expect(tomorrowView.colorDate, true);
    });
    test('date should not get colored if the homework is not overdue', () {
      var todoDate = Date(year: 2020, month: 02, day: 01);
      final hw = createHomework(todoDate: todoDate);
      assert(todoDate > currentDate);

      final view = viewFactory.createFrom(hw);

      expect(view.colorDate, false);
    });
    test('subject color should be taken from homework if specified', () {
      final hw = createHomework(subjectColor: Color(1234));

      final view = viewFactory.createFrom(hw);

      expect(view.subjectColor, Color(1234));
    });

    test('subjecet color should be the default color if homework has none', () {
      final hw = createHomework(subjectColor: null);

      final view = viewFactory.createFrom(hw);

      expect(view.subjectColor, defaultColor);
    });
  });
}
