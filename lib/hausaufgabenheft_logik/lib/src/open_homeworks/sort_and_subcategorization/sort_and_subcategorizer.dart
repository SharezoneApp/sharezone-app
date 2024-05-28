// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';

class HomeworkSortAndSubcategorizer {
  final StudentHomeworkViewFactory _viewFactory;
  final Date Function() getCurrentDate;

  HomeworkSortAndSubcategorizer({
    required Color defaultColor,
    required this.getCurrentDate,
  }) : _viewFactory = StudentHomeworkViewFactory(
          defaultColorValue: defaultColor.value,
          getCurrentDate: getCurrentDate,
        );

  List<HomeworkSectionView> sortAndSubcategorize(
      List<HomeworkReadModel> homeworks, Sort<HomeworkReadModel> sort) {
    homeworks.sortWith(sort);

    final matchingSubcategorizer = switch (sort) {
      SubjectSmallestDateAndTitleSort() =>
        _SubjectSubcategeorizer(_viewFactory),
      SmallestDateSubjectAndTitleSort() =>
        _TodoDateSubcategorizer(getCurrentDate(), _viewFactory),
    };

    return matchingSubcategorizer.subcategorize(homeworks);
  }
}

abstract class _Subcategorizer {
  List<HomeworkSectionView> subcategorize(List<HomeworkReadModel> homeworks);
}

class _SubjectSubcategeorizer extends _Subcategorizer {
  final StudentHomeworkViewFactory _viewFactory;

  _SubjectSubcategeorizer(this._viewFactory);

  @override
  List<HomeworkSectionView> subcategorize(List<HomeworkReadModel> homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    final homeworkSections = <HomeworkSectionView>[];
    for (final subject in subjects) {
      final List<HomeworkReadModel> homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toList();

      final homeworkViewsWithSubject =
          homeworksWithSubject.map((h) => _viewFactory.createFrom(h)).toList();

      homeworkSections
          .add(HomeworkSectionView(subject.name, homeworkViewsWithSubject));
    }
    return homeworkSections;
  }
}

class _TodoDateSubcategorizer extends _Subcategorizer {
  final Date currentDate;
  final StudentHomeworkViewFactory _viewFactory;

  _TodoDateSubcategorizer(this.currentDate, this._viewFactory);

  @override
  List<HomeworkSectionView> subcategorize(List<HomeworkReadModel> homeworks) {
    final latestHomeworkList = homeworks;
    final now = currentDate;
    final tomorrow = now.addDays(1);
    final in2Days = tomorrow.addDays(1);

    final List<HomeworkReadModel> overdueHomework = latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) < now)
        .toList();
    final List<HomeworkReadModel> todayHomework = latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) == now)
        .toList();
    final List<HomeworkReadModel> tomorrowHomework = latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) == tomorrow)
        .toList();
    final List<HomeworkReadModel> in2DaysHomework = latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) == in2Days)
        .toList();
    final List<HomeworkReadModel> futureHomework = latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) > in2Days)
        .toList();

    final overdueSec = HomeworkSectionView.fromModels(
        'Überfällig', overdueHomework, _viewFactory);
    final todaySec =
        HomeworkSectionView.fromModels('Heute', todayHomework, _viewFactory);
    final tomorrowSec = HomeworkSectionView.fromModels(
        'Morgen', tomorrowHomework, _viewFactory);
    final inTwoDaysSec = HomeworkSectionView.fromModels(
        'Übermorgen', in2DaysHomework, _viewFactory);
    final afterTwoDaysSec =
        HomeworkSectionView.fromModels('Später', futureHomework, _viewFactory);

    final sections = [
      overdueSec,
      todaySec,
      tomorrowSec,
      inTwoDaysSec,
      afterTwoDaysSec
    ];

    return sections.where((section) => section.isNotEmpty).toList();
  }
}
