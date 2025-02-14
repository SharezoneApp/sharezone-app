// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:hausaufgabenheft_logik/src/shared/sort_and_subcategorizer.dart';

class TeacherAndParentOpenHomeworkListViewFactory {
  final HomeworkSortAndSubcategorizer<TeacherHomeworkReadModel>
  _sortAndSubcategorizer;
  final TeacherAndParentHomeworkViewFactory _viewFactory;

  TeacherAndParentOpenHomeworkListViewFactory(
    this._sortAndSubcategorizer,
    this._viewFactory,
  );

  TeacherAndParentOpenHomeworkListView create(
    IList<TeacherHomeworkReadModel> openHomeworks,
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

    return TeacherAndParentOpenHomeworkListView(views, sorting: sort.toEnum());
  }
}
