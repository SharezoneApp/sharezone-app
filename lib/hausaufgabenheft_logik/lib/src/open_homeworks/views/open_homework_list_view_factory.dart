// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/src/models/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/models.dart';
import 'package:hausaufgabenheft_logik/src/homework_list_extensions.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/sort.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort_and_subcategorizer.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/homework_sort_enum_sort_object_conversion_extensions.dart';

import 'open_homework_list_view.dart';

class OpenHomeworkListViewFactory {
  final HomeworkSortAndSubcategorizer _sortAndSubcategorizer;
  final Date Function() _getCurrentDate;

  OpenHomeworkListViewFactory(
      this._sortAndSubcategorizer, this._getCurrentDate);

  OpenHomeworkListView create(
      IList<HomeworkReadModel> openHomeworks, Sort<HomeworkReadModel> sort) {
    final homeworkSectionViews =
        _sortAndSubcategorizer.sortAndSubcategorize(openHomeworks, sort);

    final showCompleteOverdueHomeworkPrompt =
        _shouldShowCompleteOverdueHomeworkPrompt(openHomeworks);

    return OpenHomeworkListView(
      homeworkSectionViews,
      showCompleteOverdueHomeworkPrompt: showCompleteOverdueHomeworkPrompt,
      sorting: sort.toEnum(),
    );
  }

  bool _shouldShowCompleteOverdueHomeworkPrompt(
      IList<HomeworkReadModel> openHomeworks) {
    var now = _getCurrentDate();
    var overdueOpenHomeworks = openHomeworks.getOverdue(now);
    return overdueOpenHomeworks.length > 2;
  }
}
