// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/sort.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/homework_section_view.dart';

import 'subcategorizer.dart';

class HomeworkSortAndSubcategorizer {
  Subcategorizer Function(Sort<HomeworkReadModel> sortToMatch)
      getMatchingSubcategorizer;

  HomeworkSortAndSubcategorizer(this.getMatchingSubcategorizer);

  List<HomeworkSectionView> sortAndSubcategorize(
      HomeworkList homeworks, Sort<HomeworkReadModel> sort) {
    homeworks.sortWith(sort);
    return getMatchingSubcategorizer(sort).subcategorize(homeworks);
  }
}
