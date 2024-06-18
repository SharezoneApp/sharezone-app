import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

class HomeworkPageApi {
  final StudentHomeworkPageApi students;
  final TeacherAndParentHomeworkPageApi teachersAndParents;

  HomeworkPageApi({
    required this.students,
    required this.teachersAndParents,
  });
}

abstract class StudentHomeworkPageApi implements HomeworkCompletionDispatcher {
  Stream<IList<HomeworkReadModel>> get openHomeworks;
  LazyLoadingController<HomeworkReadModel>
      getLazyLoadingCompletedHomeworksController(int nrOfInitialHomeworkToLoad);
  Future<void> completeHomework(
      HomeworkId homeworkId, CompletionStatus newCompletionStatus);
  Future<IList<HomeworkId>> getOpenOverdueHomeworkIds();
  @override
  void dispatch(HomeworkCompletion homeworkCompletion) {
    completeHomework(
        homeworkCompletion.homeworkId, homeworkCompletion.newCompletionValue);
  }
}

abstract class TeacherAndParentHomeworkPageApi {
  Stream<IList<TeacherHomeworkReadModel>> get openHomeworks;
  LazyLoadingController<TeacherHomeworkReadModel>
      getLazyLoadingArchivedHomeworksController(int nrOfInitialHomeworkToLoad);
}
