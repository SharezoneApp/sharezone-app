import 'package:equatable/equatable.dart';

abstract class CompletedHomeworksViewBlocEvent extends Equatable {}

class StartTransformingHomeworks extends CompletedHomeworksViewBlocEvent {
  @override
  List<Object> get props => [];
}

class AdvanceCompletedHomeworks extends CompletedHomeworksViewBlocEvent {
  final int advanceBy;
  @override
  List<Object> get props => [advanceBy];
  AdvanceCompletedHomeworks(this.advanceBy);
}
