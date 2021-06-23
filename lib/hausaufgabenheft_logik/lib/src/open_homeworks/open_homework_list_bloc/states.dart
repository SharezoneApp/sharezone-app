import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';

abstract class OpenHomeworkListBlocState {}

class Uninitialized extends OpenHomeworkListBlocState {}

class Success extends OpenHomeworkListBlocState {
  final HomeworkList homeworks;

  Success(this.homeworks);
}
