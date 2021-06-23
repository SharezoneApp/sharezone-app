import 'package:equatable/equatable.dart';

import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homwork_list_view.dart';

abstract class CompletedHomeworksViewBlocState extends Equatable {}

class Loading extends CompletedHomeworksViewBlocState {
  @override
  List<Object> get props => [];
}

class Success extends CompletedHomeworksViewBlocState {
  final CompletedHomeworkListView completedHomeworksView;

  Success(this.completedHomeworksView);

  @override
  List<Object> get props => [completedHomeworksView];
}
