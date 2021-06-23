import 'dart:async';
import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:sharezone/util/API.dart';

class HomeworkCardBloc extends BlocBase {
  final SharezoneGateway api;
  final HomeworkDto homework;
  final BehaviorSubject<bool> _isDoneSubject = BehaviorSubject();
  final _toggleIsDoneController = StreamController<bool>();

  HomeworkCardBloc(this.api, this.homework)
      : assert(homework.forUsers.containsKey(api.userId.toString()) != null,
            "User uID is in Homework map") {
    final bool isDoneForUser = homework.forUsers[api.userId.toString()];
    _isDoneSubject.add(isDoneForUser);

    _toggleIsDoneController.stream
        .listen((homeworkDone) => _changeValue(homeworkDone));
  }

  void _changeValue(bool newValue) {
    api.homework.changeIsHomeworkDoneTo(homework.id, newValue);
    _isDoneSubject.add(newValue); // Change value locally
  }

  /// If the User with the key [api.userId] in the [Map] [homework.forUsers] has the
  /// value true or false, so if he's done the homework or not.
  Stream<bool> get isDone => _isDoneSubject;

  /// Toggle if the User with the key [api.userId] in the [Map] [homework.forUsers]
  /// has done the homework, so if the value is true or false.
  Sink<bool> get toggleIsDone => _toggleIsDoneController;

  @override
  void dispose() {
    _toggleIsDoneController.close();
  }
}
