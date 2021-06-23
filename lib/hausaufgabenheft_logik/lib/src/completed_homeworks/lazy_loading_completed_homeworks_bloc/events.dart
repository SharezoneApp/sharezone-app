import 'package:equatable/equatable.dart';

abstract class LazyLoadingCompletedHomeworksEvent extends Equatable {}

class LoadCompletedHomeworks extends LazyLoadingCompletedHomeworksEvent {
  final int numberOfHomeworksToLoad;

  LoadCompletedHomeworks(this.numberOfHomeworksToLoad);

  @override
  List<Object> get props => [numberOfHomeworksToLoad];

  @override
  String toString() {
    return 'LoadCompletedHomeworks(numberOfHomeworksToLoad: $numberOfHomeworksToLoad)';
  }
}

class AdvanceCompletedHomeworks extends LazyLoadingCompletedHomeworksEvent {
  final int advanceBy;

  AdvanceCompletedHomeworks(this.advanceBy);

  @override
  List<Object> get props => [advanceBy];

  @override
  String toString() {
    return 'AdvanceCompletedHomeworks(advanceBy: $advanceBy)';
  }
}
