// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    hide
        SortWith,
        Sort,
        SubjectSmallestDateAndTitleSort,
        SmallestDateSubjectAndTitleSort;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:hausaufgabenheft_logik/src/lehrer/homework_list_extensions.dart';

import 'sort/homework_sorts.dart';

class TeacherHomeworkSortAndSubcategorizer {
  final TeacherHomeworkViewFactory _viewFactory;
  final Date Function() getCurrentDate;

  TeacherHomeworkSortAndSubcategorizer({
    required Color defaultColor,
    required this.getCurrentDate,
  }) : _viewFactory = TeacherHomeworkViewFactory(
          defaultColorValue: defaultColor.value,
          getCurrentDate: getCurrentDate,
        );

  IList<TeacherHomeworkSectionView> sortAndSubcategorize(
      IList<TeacherHomeworkReadModel> homeworks,
      Sort<TeacherHomeworkReadModel> sort) {
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
  IList<TeacherHomeworkSectionView> subcategorize(
      IList<TeacherHomeworkReadModel> homeworks);
}

class _SubjectSubcategeorizer extends _Subcategorizer {
  final TeacherHomeworkViewFactory _viewFactory;

  _SubjectSubcategeorizer(this._viewFactory);

  @override
  IList<TeacherHomeworkSectionView> subcategorize(
      IList<TeacherHomeworkReadModel> homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    var homeworkSections = IList<TeacherHomeworkSectionView>();
    for (final subject in subjects) {
      final IList<TeacherHomeworkReadModel> homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toIList();

      final homeworkViewsWithSubject =
          homeworksWithSubject.map((h) => _viewFactory.createFrom(h)).toIList();

      homeworkSections = homeworkSections.add(
          TeacherHomeworkSectionView(subject.name, homeworkViewsWithSubject));
    }
    return homeworkSections;
  }
}

class _TodoDateSubcategorizer extends _Subcategorizer {
  final Date currentDate;
  final TeacherHomeworkViewFactory _viewFactory;

  _TodoDateSubcategorizer(this.currentDate, this._viewFactory);

  @override
  IList<TeacherHomeworkSectionView> subcategorize(
      IList<TeacherHomeworkReadModel> homeworks) {
    final now = currentDate;
    final tomorrow = now.addDays(1);
    final in2Days = tomorrow.addDays(1);

    final IList<TeacherHomeworkReadModel> overdueHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) < now).toIList();
    final IList<TeacherHomeworkReadModel> todayHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) == now).toIList();
    final IList<TeacherHomeworkReadModel> tomorrowHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) == tomorrow)
        .toIList();
    final IList<TeacherHomeworkReadModel> in2DaysHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) == in2Days)
        .toIList();
    final IList<TeacherHomeworkReadModel> futureHomework = homeworks
        .where((h) => Date.fromDateTime(h.todoDate) > in2Days)
        .toIList();

    final overdueSec = TeacherHomeworkSectionView.fromModels(
        'Überfällig', overdueHomework, _viewFactory);
    final todaySec = TeacherHomeworkSectionView.fromModels(
        'Heute', todayHomework, _viewFactory);
    final tomorrowSec = TeacherHomeworkSectionView.fromModels(
        'Morgen', tomorrowHomework, _viewFactory);
    final inTwoDaysSec = TeacherHomeworkSectionView.fromModels(
        'Übermorgen', in2DaysHomework, _viewFactory);
    final afterTwoDaysSec = TeacherHomeworkSectionView.fromModels(
        'Später', futureHomework, _viewFactory);

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
