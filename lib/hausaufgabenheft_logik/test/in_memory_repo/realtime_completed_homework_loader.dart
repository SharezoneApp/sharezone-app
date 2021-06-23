import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';

abstract class RealtimeCompletedHomeworkLoader {
  Stream<List<HomeworkReadModel>> loadMostRecentHomeworks(
      int numberOfHomeworks);
}
