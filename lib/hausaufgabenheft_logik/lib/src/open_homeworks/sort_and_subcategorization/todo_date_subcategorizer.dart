// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/homework_section_view.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';

import 'subcategorizer.dart';

class TodoDateSubcategorizer extends Subcategorizer {
  final Date currentDate;
  final StudentHomeworkViewFactory _viewFactory;

  TodoDateSubcategorizer(this.currentDate, this._viewFactory);

  @override
  List<HomeworkSectionView> subcategorize(HomeworkList homeworks) {
    final _latestHomeworkList = homeworks;
    final now = currentDate;
    final tomorrow = now.addDaysWithNoChecking(1);
    final in2Days = tomorrow.addDaysWithNoChecking(1);

    final overdueHomework = _latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) < now)
        .toList();
    final todayHomework = _latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) == now)
        .toList();
    final tomorrowHomework = _latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) == tomorrow)
        .toList();
    final in2DaysHomework = _latestHomeworkList
        .where((h) => Date.fromDateTime(h.todoDate) == in2Days)
        .toList();
    final futureHomework = _latestHomeworkList
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
