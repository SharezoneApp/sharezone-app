import 'package:equatable/equatable.dart';

abstract class OpenHomeworkListBlocEvent extends Equatable {}

class LoadHomeworks extends OpenHomeworkListBlocEvent {
  @override
  List<Object> get props => [];
}
