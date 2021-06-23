import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework_completion_status.dart';

/// The boundary to the outer world.
/// The only purpose for this class is to change the completion status of a
/// homework.
/// This class should be implemented in another package where it is bound to the
/// backend service used in production, e.g. Firebase.
abstract class HomeworkCompletionDispatcher {
  void dispatch(HomeworkCompletion homeworkCompletion);
}

class HomeworkCompletion {
  final HomeworkId homeworkId;
  final CompletionStatus newCompletionValue;

  HomeworkCompletion(this.homeworkId, this.newCompletionValue);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is HomeworkCompletion && other.homeworkId == homeworkId;
  }

  @override
  int get hashCode => homeworkId.hashCode;
}
