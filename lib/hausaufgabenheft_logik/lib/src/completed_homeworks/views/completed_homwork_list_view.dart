import 'package:meta/meta.dart';

import '../../views/homework_view.dart';

class CompletedHomeworkListView {
  final bool loadedAllCompletedHomeworks;
  final List<StudentHomeworkView> orderedHomeworks;

  CompletedHomeworkListView(this.orderedHomeworks,
      {@required this.loadedAllCompletedHomeworks});

  int get numberOfHomeworks => orderedHomeworks.length;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is CompletedHomeworkListView &&
            other.orderedHomeworks == orderedHomeworks &&
            other.loadedAllCompletedHomeworks == loadedAllCompletedHomeworks;
  }

  @override
  int get hashCode =>
      orderedHomeworks.hashCode ^ loadedAllCompletedHomeworks.hashCode;
}
