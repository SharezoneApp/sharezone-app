import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homwork_list_view.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view.dart';

abstract class HomeworkPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class Success extends HomeworkPageState {
  final CompletedHomeworkListView completed;
  final OpenHomeworkListView open;

  Success(this.completed, this.open);

  @override
  List<Object> get props => [completed, open];

  @override
  String toString() {
    return 'Success(completed: $completed, open: $open)';
  }
}

/// Bloc has not yet been told to load the homeworks.
class Uninitialized extends HomeworkPageState {
  @override
  String toString() {
    return 'HomeworkPageStateUninitialized';
  }
}
