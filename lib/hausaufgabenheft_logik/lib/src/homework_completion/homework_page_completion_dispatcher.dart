import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:meta/meta.dart';

/// The [HomeworkPageCompletionDispatcher] is a homework page sepecific input for
/// [HomeworkCompletionEvent]s.
///
/// Delegates all incomming Events to the [HomeworkCompletionDispatcher].
///
/// The fundamental difference between both classes is that this class is
/// tailored to the HomeworkPage e.g. through the
/// [AllOverdueHomeworkCompletionEvent] while the [HomeworkCompletionDispatcher]
/// is not bound to the homework page.
class HomeworkPageCompletionDispatcher {
  final Future<List<HomeworkId>> Function() getCurrentOverdueHomeworkIds;
  final HomeworkCompletionDispatcher _homeworkCompletionDispatcher;

  HomeworkPageCompletionDispatcher(this._homeworkCompletionDispatcher,
      {@required this.getCurrentOverdueHomeworkIds});

  Future<void> add(HomeworkCompletionEvent event) async {
    if (event is SingleHomeworkCompletionEvent) {
      _homeworkCompletionDispatcher.dispatch(
        HomeworkCompletion(
          HomeworkId(event.homeworkId),
          event.newValue ? CompletionStatus.completed : CompletionStatus.open,
        ),
      );
    } else if (event is AllOverdueHomeworkCompletionEvent) {
      final overdueHwIds = await getCurrentOverdueHomeworkIds();
      for (final overdueHwId in overdueHwIds) {
        _homeworkCompletionDispatcher.dispatch(
          HomeworkCompletion(overdueHwId, CompletionStatus.completed),
        );
      }
    } else {
      throw UnimplementedError('$event is not implemented');
    }
  }
}

abstract class HomeworkCompletionEvent extends Equatable {}

class SingleHomeworkCompletionEvent extends HomeworkCompletionEvent {
  final String homeworkId;
  final bool newValue;

  SingleHomeworkCompletionEvent(this.homeworkId, this.newValue);

  @override
  List<Object> get props => [homeworkId];
}

/// Will change the completion status of all open homeworks, where the todo date
/// is before today, to completed.
class AllOverdueHomeworkCompletionEvent extends HomeworkCompletionEvent {
  @override
  List<Object> get props => [];
}
