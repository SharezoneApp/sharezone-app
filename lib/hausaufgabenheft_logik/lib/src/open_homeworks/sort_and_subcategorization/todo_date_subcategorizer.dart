// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';

import 'subcategorizer.dart';

class TodoDateSubcategorizer extends Subcategorizer {
  final Date currentDate;
  final StudentHomeworkViewFactory _viewFactory;

  TodoDateSubcategorizer(this.currentDate, this._viewFactory);

  @override
  List<HomeworkSectionView> subcategorize(HomeworkList homeworks) {
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
