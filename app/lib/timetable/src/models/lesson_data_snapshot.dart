import 'package:group_domain_models/group_domain_models.dart';

import 'package:meta/meta.dart';

import 'lesson.dart';

class LessonDataSnapshot {
  final List<Lesson> lessons;
  final Map<String, GroupInfo> groupInfos;

  const LessonDataSnapshot({
    @required this.lessons,
    @required this.groupInfos,
  });
}
