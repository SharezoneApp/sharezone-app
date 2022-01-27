// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/homework_sorts.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';

import 'subcategorizer.dart';
import 'subject_subcategorizer.dart';
import 'todo_date_subcategorizer.dart';

class SubcategorizerFactory {
  final StudentHomeworkViewFactory _viewFactory;

  SubcategorizerFactory(this._viewFactory);

  Subcategorizer getMatchingSubcategorizer(Sort sort) {
    if (sort is SubjectSmallestDateAndTitleSort) {
      return SubjectSubcategeorizer(_viewFactory);
    } else if (sort is SmallestDateSubjectAndTitleSort) {
      return TodoDateSubcategorizer(sort.getCurrentDate(), _viewFactory);
    } else {
      throw UnimplementedError('No matching Subcategorizer for $sort');
    }
  }
}
