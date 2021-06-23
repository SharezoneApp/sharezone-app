import 'package:firebase_hausaufgabenheft_logik/src/realtime_completed_homework_loader.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:rxdart/subjects.dart';

class InMemoryHomeworkLoader extends RealtimeCompletedHomeworkLoader {
  final BehaviorSubject<List<HomeworkReadModel>> _completedHomeworksSubject;

  InMemoryHomeworkLoader(this._completedHomeworksSubject);

  @override
  Stream<List<HomeworkReadModel>> loadMostRecentHomeworks(
      int numberOfHomeworks) {
    return _completedHomeworksSubject.map((homeworks) {
      if (homeworks.length < numberOfHomeworks) return homeworks;
      return homeworks.sublist(0, numberOfHomeworks);
    });
  }
}
