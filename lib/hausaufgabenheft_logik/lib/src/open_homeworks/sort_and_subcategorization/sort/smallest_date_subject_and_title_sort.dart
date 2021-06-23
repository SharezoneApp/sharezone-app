import '../../../models/homework/homework.dart';
import '../../../models/date.dart';
import 'src/sort.dart';
import 'src/sort_with_operations.dart';
import 'src/homework_attribute_sorts.dart';

/// Sorts the homeworks firstly by date (earliest date first).
/// If they have the same date, they will be sorted alphabetically by subject.
/// If they have the same date and subject, they will be sorted alphabetically by title.
class SmallestDateSubjectAndTitleSort extends Sort<HomeworkReadModel> {
  Date Function() getCurrentDate;

  SmallestDateSubjectAndTitleSort({this.getCurrentDate}) {
    getCurrentDate ??= () => Date.now();
  }

  @override
  List<HomeworkReadModel> sort(List<HomeworkReadModel> list) {
    sortWithOperations<HomeworkReadModel>(
        list, List.from([dateSort, subjectSort, titleSort]));
    return list;
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is SmallestDateSubjectAndTitleSort &&
            other.getCurrentDate == getCurrentDate;
  }

  @override
  int get hashCode => getCurrentDate.hashCode;
}
