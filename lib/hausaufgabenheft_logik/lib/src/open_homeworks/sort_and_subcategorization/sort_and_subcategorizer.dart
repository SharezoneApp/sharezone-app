// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';

class HomeworkSortAndSubcategorizer {
  final StudentHomeworkViewFactory viewFactory;
  final Date Function() getCurrentDate;

  HomeworkSortAndSubcategorizer({
    required this.viewFactory,
    required this.getCurrentDate,
  });

  IList<HomeworkSectionView> sortAndSubcategorize(
      IList<StudentHomeworkReadModel> homeworks,
      Sort<StudentHomeworkReadModel> sort) {
    final sorted = homeworks.sortWith(sort);

    return switch (sort) {
      SmallestDateSubjectAndTitleSort() => _subcategorizeByDate(sorted),
      SubjectSmallestDateAndTitleSort() => _subcategorizeBySubject(sorted),
    };
  }

  IList<HomeworkSectionView> _subcategorizeByDate(
      IList<StudentHomeworkReadModel> homeworks) {
    final now = getCurrentDate();
    final tomorrow = now.addDays(1);
    final in2Days = tomorrow.addDays(1);

    final IList<StudentHomeworkReadModel> overdueHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) < now).toIList();
    final IList<StudentHomeworkReadModel> todayHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) == now).toIList();
    final IList<StudentHomeworkReadModel> tomorrowHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) == tomorrow)
        .toIList();
    final IList<StudentHomeworkReadModel> in2DaysHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) == in2Days)
        .toIList();
    final IList<StudentHomeworkReadModel> futureHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) > in2Days)
        .toIList();

    final overdueSec = HomeworkSectionView.fromModels(
        'Überfällig', overdueHomework, viewFactory);
    final todaySec =
        HomeworkSectionView.fromModels('Heute', todayHomework, viewFactory);
    final tomorrowSec =
        HomeworkSectionView.fromModels('Morgen', tomorrowHomework, viewFactory);
    final inTwoDaysSec = HomeworkSectionView.fromModels(
        'Übermorgen', in2DaysHomework, viewFactory);
    final afterTwoDaysSec =
        HomeworkSectionView.fromModels('Später', futureHomework, viewFactory);

    final sections = [
      overdueSec,
      todaySec,
      tomorrowSec,
      inTwoDaysSec,
      afterTwoDaysSec
    ];

    return sections.where((section) => section.isNotEmpty).toIList();
  }

  IList<HomeworkSectionView> _subcategorizeBySubject(
      IList<StudentHomeworkReadModel> homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    var homeworkSections = IList<HomeworkSectionView>();
    for (final subject in subjects) {
      final IList<StudentHomeworkReadModel> homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toIList();

      final homeworkViewsWithSubject =
          homeworksWithSubject.map((h) => viewFactory.createFrom(h)).toIList();

      homeworkSections = homeworkSections
          .add(HomeworkSectionView(subject.name, homeworkViewsWithSubject));
    }
    return homeworkSections;
  }
}
