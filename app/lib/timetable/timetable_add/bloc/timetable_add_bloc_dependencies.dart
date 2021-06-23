import 'package:meta/meta.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';
import 'package:sharezone/util/api/timetableGateway.dart';

class TimetableAddBlocDependencies {
  final TimetableGateway gateway;
  final LessonLengthCache lessonLengthCache;

  TimetableAddBlocDependencies({
    @required this.gateway,
    @required this.lessonLengthCache,
  });
}
