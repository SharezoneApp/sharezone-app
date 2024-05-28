// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

  IList<HomeworkSectionView> sortAndSubcategorize(
      IList<HomeworkReadModel> homeworks, Sort<HomeworkReadModel> sort) {
    final sorted = homeworks.sortWith(sort);

    final matchingSubcategorizer = switch (sort) {
      SubjectSmallestDateAndTitleSort() =>
        _SubjectSubcategeorizer(_viewFactory),
      SmallestDateSubjectAndTitleSort() =>
        _TodoDateSubcategorizer(getCurrentDate(), _viewFactory),
    };

    return matchingSubcategorizer.subcategorize(sorted);
  }
}

abstract class _Subcategorizer {
  IList<HomeworkSectionView> subcategorize(IList<HomeworkReadModel> homeworks);
}

class _SubjectSubcategeorizer extends _Subcategorizer {
  final StudentHomeworkViewFactory _viewFactory;

  _SubjectSubcategeorizer(this._viewFactory);

  @override
  IList<HomeworkSectionView> subcategorize(IList<HomeworkReadModel> homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    var homeworkSections = IList<HomeworkSectionView>();
    for (final subject in subjects) {
      final IList<HomeworkReadModel> homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toIList();

      final homeworkViewsWithSubject =
          homeworksWithSubject.map((h) => _viewFactory.createFrom(h)).toIList();

      homeworkSections = homeworkSections
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
  IList<HomeworkSectionView> subcategorize(IList<HomeworkReadModel> homeworks) {
    final now = currentDate;
    final tomorrow = now.addDays(1);
    final in2Days = tomorrow.addDays(1);

    final IList<HomeworkReadModel> overdueHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) < now).toIList();
    final IList<HomeworkReadModel> todayHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) == now).toIList();
    final IList<HomeworkReadModel> tomorrowHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) == tomorrow)
        .toIList();
    final IList<HomeworkReadModel> in2DaysHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) == in2Days)
        .toIList();
    final IList<HomeworkReadModel> futureHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) > in2Days)
        .toIList();

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

    return sections.where((section) => section.isNotEmpty).toIList();
  }
}
