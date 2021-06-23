import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/homework_section_view.dart';

abstract class Subcategorizer {
  List<HomeworkSectionView> subcategorize(HomeworkList homeworks);
}
