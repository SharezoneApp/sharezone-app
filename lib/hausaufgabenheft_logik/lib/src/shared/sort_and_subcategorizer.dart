// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

class HomeworkSortAndSubcategorizer<T extends BaseHomeworkReadModel> {
  final Date Function() getCurrentDate;

  HomeworkSortAndSubcategorizer({required this.getCurrentDate});

  IList<HomeworkSectionView<T>> sortAndSubcategorize(
    IList<T> homeworks,
    Sort<BaseHomeworkReadModel> sort,
  ) {
    final sorted = homeworks.sortWith(sort);

    return switch (sort) {
      SmallestDateSubjectAndTitleSort() => _subcategorizeByDate(sorted),
      SubjectSmallestDateAndTitleSort() => _subcategorizeBySubject(sorted),
      WeekdayDateSubjectAndTitleSort() => _subcategorizeByWeekday(sorted),
    };
  }

  IList<HomeworkSectionView<T>> _subcategorizeByDate(IList<T> homeworks) {
    final now = getCurrentDate();
    final tomorrow = now.addDays(1);
    final in2Days = tomorrow.addDays(1);

    final IList<T> overdueHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) < now).toIList();
    final IList<T> todayHomework =
        homeworks.where((h) => Date.fromDateTime(h.todoDate) == now).toIList();
    final IList<T> tomorrowHomework =
        homeworks
            .where((h) => Date.fromDateTime(h.todoDate) == tomorrow)
            .toIList();
    final IList<T> in2DaysHomework =
        homeworks
            .where((h) => Date.fromDateTime(h.todoDate) == in2Days)
            .toIList();
    final IList<T> futureHomework =
        homeworks
            .where((h) => Date.fromDateTime(h.todoDate) > in2Days)
            .toIList();

    final overdueSec = HomeworkSectionView('Überfällig', overdueHomework);
    final todaySec = HomeworkSectionView('Heute', todayHomework);
    final tomorrowSec = HomeworkSectionView('Morgen', tomorrowHomework);
    final inTwoDaysSec = HomeworkSectionView('Übermorgen', in2DaysHomework);
    final afterTwoDaysSec = HomeworkSectionView('Später', futureHomework);

    final sections = [
      overdueSec,
      todaySec,
      tomorrowSec,
      inTwoDaysSec,
      afterTwoDaysSec,
    ];

    return sections.where((section) => section.isNotEmpty).toIList();
  }

  IList<HomeworkSectionView<T>> _subcategorizeBySubject(IList<T> homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    var homeworkSections = IList<HomeworkSectionView<T>>();
    for (final subject in subjects) {
      final IList<T> homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toIList();

      homeworkSections = homeworkSections.add(
        HomeworkSectionView(subject.name, homeworksWithSubject),
      );
    }
    return homeworkSections;
  }

  IList<HomeworkSectionView<T>> _subcategorizeByWeekday(IList<T> homeworks) {
    final Map<int, List<T>> map = {for (var i = 1; i <= 7; i++) i: <T>[]};
    for (final hw in homeworks) {
      map[hw.todoDate.weekday]!.add(hw);
    }
    const titles = {
      1: 'Montag',
      2: 'Dienstag',
      3: 'Mittwoch',
      4: 'Donnerstag',
      5: 'Freitag',
      6: 'Samstag',
      7: 'Sonntag',
    };
    final sections = <HomeworkSectionView<T>>[];
    for (var i = 1; i <= 7; i++) {
      final list = map[i]!;
      if (list.isNotEmpty) {
        sections.add(
          HomeworkSectionView(titles[i]!, list.toIList()),
        );
      }
    }
    return sections.toIList();
  }
}
