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
