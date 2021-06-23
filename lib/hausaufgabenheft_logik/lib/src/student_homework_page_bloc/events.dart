import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

abstract class HomeworkPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Sorts all open homeworks with the given [sort].
class OpenHwSortingChanged extends HomeworkPageEvent {
  final HomeworkSort sort;

  OpenHwSortingChanged(this.sort);

  @override
  List<Object> get props => [sort];

  @override
  String toString() {
    return 'SortingChanged(sort: $sort)';
  }
}

/// Changes the completion status of the homework with the given [homeworkId]
/// to [newValue].
class CompletionStatusChanged extends HomeworkPageEvent {
  final String homeworkId;
  final bool newValue;

  CompletionStatusChanged(this.homeworkId, this.newValue);

  @override
  List<Object> get props => [homeworkId];

  @override
  String toString() {
    return 'DoneHomework(homeworkId: $homeworkId)';
  }
}

/// Marks the completion status of all open homeworks where the todo date lies
/// before today as completed.
class CompletedAllOverdue extends HomeworkPageEvent {
  @override
  String toString() {
    return 'CompletedAllOverdue';
  }
}

/// Tells the bloc to start loading homeworks
class LoadHomeworks extends HomeworkPageEvent {
  @override
  String toString() {
    return 'LoadHomeworks';
  }
}

/// Advances the number of loaded, completed homeworks by [advanceBy].
/// For example:
/// Initial state: 5 completed Homeworks loaded.
/// Event dispatched: [AdvanceCompletedHomeworks] with [advanceBy] = 5
/// New state: 10 completed homeworks loaded.
///
/// If all homeworks are already loaded this won't do anything.
class AdvanceCompletedHomeworks extends HomeworkPageEvent {
  final int advanceBy;

  @override
  List<Object> get props => [advanceBy];

  AdvanceCompletedHomeworks(this.advanceBy);

  @override
  String toString() {
    return 'AdvanceCompletedHomeworks(advanceBy: $advanceBy)';
  }
}
