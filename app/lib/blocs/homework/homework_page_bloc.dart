// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/util/API.dart';
import 'package:sharezone_common/api_errors.dart';

class HomeworkToggleDone {
  final String homeworkDocumentID;
  final bool newHomeworkValue;

  HomeworkToggleDone(this.homeworkDocumentID, this.newHomeworkValue);
}

class HomeworkPageBloc extends BlocBase {
  /// The [SharezoneGateway] used to get [HomeworkDto].
  final SharezoneGateway api;

  // This could maybe be in an own Bloc for homework
  final _toggleIsHomeworkDoneToController =
      StreamController<HomeworkToggleDone>();
  final BehaviorSubject<List<HomeworkDto>> _homeworkListSubject =
      BehaviorSubject();
  final BehaviorSubject<List<HomeworkDto>> _homeworkDoneSubject =
      BehaviorSubject();
  final BehaviorSubject<List<HomeworkDto>> _homeworkNotDoneSubject =
      BehaviorSubject();
  final _addHomeworkController = StreamController<HomeworkDto>();
  final BehaviorSubject<List<dynamic>> _errorsSubject =
      BehaviorSubject.seeded([]);

  /// Errors while converting [FirestoreDocument] into [HomeworkDto] from the API
  /// or any Error occuring in the bloc.
  Stream<List<dynamic>> get errors => _errorsSubject;

  /// Every [HomeworkDto] the user has.
  Stream<List<HomeworkDto>> get homeworkList => _homeworkListSubject;

  /// A [Sink] to add a [HomeworkDto] to the database.
  Sink<HomeworkDto> get addHomework => _addHomeworkController;

  /// Toggles if the [HomeworkDto] is done for the user calling it, spezified by the
  /// uID in the [SharezoneGateway]
  Sink<HomeworkToggleDone> get toggleIsHomeworkDoneTo =>
      _toggleIsHomeworkDoneToController;

  /// Every [HomeworkDto] which is done by the user, spezified by the uID in the [SharezoneGateway]
  Stream<List<HomeworkDto>> get homeworkDone => _homeworkDoneSubject;

  /// Every [HomeworkDto] which is not done by the user, spezified by the uID in the [SharezoneGateway]
  Stream<List<HomeworkDto>> get homeworkNotDone => _homeworkNotDoneSubject;

  HomeworkPageBloc(this.api) {
    _homeworkListSubject.addStream(api.homework.homeworkStream);
    api.homework.homeworkStream.listen(
        (homeworkList) => _splitHomeworkAndAddToStreams(homeworkList),
        cancelOnError: false,
        onError: (e) => _handleAPIError(e));

    _toggleIsHomeworkDoneToController.stream.listen((homeworkDone) =>
        api.homework.changeIsHomeworkDoneTo(
            homeworkDone.homeworkDocumentID, homeworkDone.newHomeworkValue));

    _addHomeworkController.stream
        .listen((homework) => api.homework.addPrivateHomework(homework, false));
  }

  /// Attention! Side-effects. Splits [homeworkList] and adds a [List] of
  /// [doneHomework] and [notDoneHomework] into [homeworkDone] and [homeworkNotDone].
  void _splitHomeworkAndAddToStreams(List<HomeworkDto> homeworkList) {
    final List<HomeworkDto> doneHomework = [];
    final List<HomeworkDto> notDoneHomework = [];

    assert(homeworkList != null);
    for (final homework in homeworkList) {
      try {
        _checkIfUserHasDoneHomework(homework)
            ? doneHomework.add(homework)
            : notDoneHomework.add(homework);
      } on Exception catch (e) {
        print(
            "Error beim Zuweisen zu gemachten und nicht gemachten Hausaufgaben: $e");
      }
    }

    _homeworkNotDoneSubject.add(notDoneHomework);
    _homeworkDoneSubject.add(doneHomework);
  }

  /// Returns the boolean value of the "userID - boolean" key-value pair.
  bool _checkIfUserHasDoneHomework(HomeworkDto homework) {
    final uID = api.uID;
    final userMap = homework.forUsers;
    assert(userMap.containsKey(uID), "User should be in the Map");
    return userMap[uID];
  }

  /// Expects a [List] of [DeserializeFirestoreDocException], but tries to handle other cases, and adds it to [_errorsSubject].
  void _handleAPIError(error, [dynamic s]) {
    print(
        "Error während dem Konvertieren der Firestore Dokumente in Hausaufgaben.");
    print('$error $s');
  }

  Future<void> checkAllOverdueHomeworks() async {
    List<HomeworkDto> homeworkNotDone = _homeworkNotDoneSubject.valueOrNull;
    if (homeworkNotDone != null && homeworkNotDone.isNotEmpty) {
      for (HomeworkDto homework in homeworkNotDone) {
        final DateTime homeworkDateTime = DateTime(homework.todoUntil.year,
            homework.todoUntil.month, homework.todoUntil.day);
        final DateTime todayDateTime = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        if (homeworkDateTime.isBefore(todayDateTime)) {
          api.homework.changeIsHomeworkDoneTo(homework.id, true);
        }
      }
    }
  }

  /// Take care of closing streams.
  @override
  void dispose() {
    _homeworkNotDoneSubject.close();
    _homeworkDoneSubject.close();
    _toggleIsHomeworkDoneToController.close();
    _errorsSubject.close();
    _addHomeworkController.close();
    _homeworkListSubject.close();
  }
}
