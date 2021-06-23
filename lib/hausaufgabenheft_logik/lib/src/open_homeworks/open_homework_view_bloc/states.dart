import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view.dart';

abstract class OpenHomeworksViewBlocState {}

class Uninitialized extends OpenHomeworksViewBlocState {}

class Success extends OpenHomeworksViewBlocState {
  final OpenHomeworkListView openHomeworkListView;

  Success(this.openHomeworkListView) : assert(openHomeworkListView != null);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is Success && other.openHomeworkListView == openHomeworkListView;
  }

  @override
  int get hashCode => openHomeworkListView.hashCode;

  @override
  String toString() {
    return 'Success(openHomeworkListView: $openHomeworkListView)';
  }
}
