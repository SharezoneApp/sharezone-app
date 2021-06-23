import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'completed_homwork_list_view.dart';
import '../../views/student_homework_view_factory.dart';

class CompletedHomeworkListViewFactory {
  final StudentHomeworkViewFactory _studentHomeworkViewFactory;

  CompletedHomeworkListViewFactory(this._studentHomeworkViewFactory);

  CompletedHomeworkListView create(
      HomeworkList completedHomeworks, bool loadedAllCompletedHomeworks) {
    final orderedHomeworks = [
      for (final completedHomework in completedHomeworks)
        _studentHomeworkViewFactory.createFrom(completedHomework)
    ];
    return CompletedHomeworkListView(orderedHomeworks,
        loadedAllCompletedHomeworks: loadedAllCompletedHomeworks);
  }
}
