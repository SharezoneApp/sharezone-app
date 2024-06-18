// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:hausaufgabenheft_logik/src/models/models.dart';

class TeacherOpenHomeworkListViewFactory {
  final TeacherHomeworkSortAndSubcategorizer _sortAndSubcategorizer;
  final Date Function() _getCurrentDate;

  TeacherOpenHomeworkListViewFactory(
      this._sortAndSubcategorizer, this._getCurrentDate);

  TeacherOpenHomeworkListView create(
      IList<TeacherHomeworkReadModel> openHomeworks,
      Sort<TeacherHomeworkReadModel> sort) {
    final homeworkSectionViews =
        _sortAndSubcategorizer.sortAndSubcategorize(openHomeworks, sort);

    return TeacherOpenHomeworkListView(
      homeworkSectionViews,
      sorting: sort.toEnum(),
    );
  }
}
