import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

abstract class RealtimeCompletedHomeworkLoader {
  Stream<List<HomeworkReadModel>> loadMostRecentHomeworks(
      int numberOfHomeworks);
}
