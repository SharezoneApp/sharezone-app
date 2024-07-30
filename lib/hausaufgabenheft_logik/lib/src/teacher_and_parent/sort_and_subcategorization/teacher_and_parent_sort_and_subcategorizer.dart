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
import 'package:hausaufgabenheft_logik/src/teacher_and_parent/teacher_and_parent_homework_list_extensions.dart';

class TeacherAndParentHomeworkSortAndSubcategorizer {
  final TeacherAndParentHomeworkViewFactory _viewFactory;
  final Date Function() getCurrentDate;

  TeacherAndParentHomeworkSortAndSubcategorizer({
    required Color defaultColor,
    required this.getCurrentDate,
  }) : _viewFactory = TeacherAndParentHomeworkViewFactory(
          defaultColorValue: defaultColor.value,
          getCurrentDate: getCurrentDate,
        );

  IList<TeacherAndParentHomeworkSectionView> sortAndSubcategorize(
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
  IList<TeacherAndParentHomeworkSectionView> subcategorize(
      IList<TeacherHomeworkReadModel> homeworks);
}

class _SubjectSubcategeorizer extends _Subcategorizer {
  final TeacherAndParentHomeworkViewFactory _viewFactory;

  _SubjectSubcategeorizer(this._viewFactory);

  @override
  IList<TeacherAndParentHomeworkSectionView> subcategorize(
      IList<TeacherHomeworkReadModel> homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    var homeworkSections = IList<TeacherAndParentHomeworkSectionView>();
    for (final subject in subjects) {
      final IList<TeacherHomeworkReadModel> homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toIList();

      final homeworkViewsWithSubject =
          homeworksWithSubject.map((h) => _viewFactory.createFrom(h)).toIList();

      homeworkSections = homeworkSections.add(
          TeacherAndParentHomeworkSectionView(
              subject.name, homeworkViewsWithSubject));
    }
    return homeworkSections;
  }
}

class _TodoDateSubcategorizer extends _Subcategorizer {
  final Date currentDate;
  final TeacherAndParentHomeworkViewFactory _viewFactory;

  _TodoDateSubcategorizer(this.currentDate, this._viewFactory);

  @override
  IList<TeacherAndParentHomeworkSectionView> subcategorize(
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

    final overdueSec = TeacherAndParentHomeworkSectionView.fromModels(
        'Überfällig', overdueHomework, _viewFactory);
    final todaySec = TeacherAndParentHomeworkSectionView.fromModels(
        'Heute', todayHomework, _viewFactory);
    final tomorrowSec = TeacherAndParentHomeworkSectionView.fromModels(
        'Morgen', tomorrowHomework, _viewFactory);
    final inTwoDaysSec = TeacherAndParentHomeworkSectionView.fromModels(
        'Übermorgen', in2DaysHomework, _viewFactory);
    final afterTwoDaysSec = TeacherAndParentHomeworkSectionView.fromModels(
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
