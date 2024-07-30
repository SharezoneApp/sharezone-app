// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

class StudentOpenHomeworkListViewFactory {
  final StudentHomeworkSortAndSubcategorizer _sortAndSubcategorizer;
  final Date Function() _getCurrentDate;

  StudentOpenHomeworkListViewFactory(
      this._sortAndSubcategorizer, this._getCurrentDate);

  StudentOpenHomeworkListView create(
      IList<StudentHomeworkReadModel> openHomeworks,
      Sort<BaseHomeworkReadModel> sort) {
    final homeworkSectionViews =
        _sortAndSubcategorizer.sortAndSubcategorize(openHomeworks, sort);

    final showCompleteOverdueHomeworkPrompt =
        _shouldShowCompleteOverdueHomeworkPrompt(openHomeworks);

    return StudentOpenHomeworkListView(
      homeworkSectionViews,
      showCompleteOverdueHomeworkPrompt: showCompleteOverdueHomeworkPrompt,
      sorting: sort.toEnum(),
    );
  }

  bool _shouldShowCompleteOverdueHomeworkPrompt(
      IList<StudentHomeworkReadModel> openHomeworks) {
    var now = _getCurrentDate();
    var overdueOpenHomeworks = openHomeworks.getOverdue(now);
    return overdueOpenHomeworks.length > 2;
  }
}
