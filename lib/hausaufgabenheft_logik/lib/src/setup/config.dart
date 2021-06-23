import 'package:meta/meta.dart';

class HausaufgabenheftConfig {
  final int defaultCourseColorValue;
  final int nrOfInitialCompletedHomeworksToLoad;

  HausaufgabenheftConfig({
    @required this.defaultCourseColorValue,
    @required this.nrOfInitialCompletedHomeworksToLoad,
  });
}
