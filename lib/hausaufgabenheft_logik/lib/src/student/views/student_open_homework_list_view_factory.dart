// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/shared/sort_and_subcategorizer.dart';
import 'package:hausaufgabenheft_logik/src/student/views/student_homework_view_factory.dart';

class StudentOpenHomeworkListViewFactory {
  final HomeworkSortAndSubcategorizer<StudentHomeworkReadModel>
  _sortAndSubcategorizer;
  final StudentHomeworkViewFactory _viewFactory;
  final Date Function() _getCurrentDate;

  StudentOpenHomeworkListViewFactory(
    this._sortAndSubcategorizer,
    this._viewFactory,
    this._getCurrentDate,
  );

  StudentOpenHomeworkListView create(
    IList<StudentHomeworkReadModel> openHomeworks,
    Sort<BaseHomeworkReadModel> sort,
  ) {
    final sortedAndSubcategorized = _sortAndSubcategorizer.sortAndSubcategorize(
      openHomeworks,
      sort,
    );

    final views =
        sortedAndSubcategorized
            .map(
              (section) => HomeworkSectionView(
                section.title,
                section.homeworks
                    .map((hw) => _viewFactory.createFrom(hw))
                    .toIList(),
              ),
            )
            .toIList();

    final showCompleteOverdueHomeworkPrompt =
        _shouldShowCompleteOverdueHomeworkPrompt(openHomeworks);

    return StudentOpenHomeworkListView(
      views,
      showCompleteOverdueHomeworkPrompt: showCompleteOverdueHomeworkPrompt,
      sorting: sort.toEnum(),
    );
  }

  bool _shouldShowCompleteOverdueHomeworkPrompt(
    IList<StudentHomeworkReadModel> openHomeworks,
  ) {
    final now = _getCurrentDate();
    final overdueOpenHomeworks = openHomeworks.getOverdue(now);
    return overdueOpenHomeworks.length > 2;
  }
}
