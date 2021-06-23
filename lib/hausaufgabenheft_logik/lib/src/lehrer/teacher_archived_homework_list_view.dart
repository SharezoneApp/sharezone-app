import 'package:meta/meta.dart';

import 'teacher_homework_view.dart';

class TeacherArchivedHomeworkListView {
  final bool loadedAllArchivedHomeworks;
  final List<TeacherHomeworkView> orderedHomeworks;

  TeacherArchivedHomeworkListView(this.orderedHomeworks,
      {@required this.loadedAllArchivedHomeworks});

  int get numberOfHomeworks => orderedHomeworks.length;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is TeacherArchivedHomeworkListView &&
            other.orderedHomeworks == orderedHomeworks &&
            other.loadedAllArchivedHomeworks == loadedAllArchivedHomeworks;
  }

  @override
  int get hashCode =>
      orderedHomeworks.hashCode ^ loadedAllArchivedHomeworks.hashCode;
}
