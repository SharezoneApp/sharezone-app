import 'dart:collection';
import 'package:hausaufgabenheft_logik/src/models/homework/homework_completion_status.dart';

import 'homework/homework.dart';
import 'date.dart';
import 'subject.dart';
import '../open_homeworks/sort_and_subcategorization/sort/src/sort.dart';

class HomeworkList extends ListBase<HomeworkReadModel> {
  final List<HomeworkReadModel> _homeworks;

  HomeworkList(List<HomeworkReadModel> homeworks)
      : assert(homeworks != null),
        _homeworks = List.from(homeworks);
  @override
  int get length => _homeworks.length;

  @override
  set length(int newLength) => _homeworks.length = newLength;

  @override
  HomeworkReadModel operator [](int index) => _homeworks[index];

  @override
  void operator []=(int index, value) => _homeworks[index] = value;

  @override // Overwritten for performance reasons as stated in ListBase
  void add(HomeworkReadModel element) => _homeworks.add(element);

  @override // Overwritten for performance reasons as stated in ListBase
  void addAll(Iterable<HomeworkReadModel> iterable) =>
      _homeworks.addAll(iterable);

  void sortWith(Sort<HomeworkReadModel> sort) => sort.sort(this);

  @override
  String toString() {
    var s = 'HomeworkList([\n';
    for (final homework in _homeworks) {
      s += '$homework\n';
    }
    s += '])';
    return s;
  }

  List<Subject> getDistinctOrderedSubjects() {
    final subjects = <Subject>{};
    for (final homework in _homeworks) {
      subjects.add(homework.subject);
    }
    return subjects.toList();
  }

  HomeworkList getOverdue([Date now]) {
    now = now ?? Date.now();
    return HomeworkList(_homeworks
        .where((homeworks) => homeworks.isOverdueRelativeTo(now))
        .toList());
  }

  HomeworkList get completed => HomeworkList(_homeworks
      .where((homework) => homework.status == CompletionStatus.completed)
      .toList());
  HomeworkList get open => HomeworkList(_homeworks
      .where((homework) => homework.status == CompletionStatus.open)
      .toList());
}
