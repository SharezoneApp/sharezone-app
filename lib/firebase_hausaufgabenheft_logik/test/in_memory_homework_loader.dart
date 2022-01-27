// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_hausaufgabenheft_logik/src/realtime_completed_homework_loader.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:rxdart/subjects.dart';

class InMemoryHomeworkLoader extends RealtimeCompletedHomeworkLoader {
  final BehaviorSubject<List<HomeworkReadModel>> _completedHomeworksSubject;

  InMemoryHomeworkLoader(this._completedHomeworksSubject);

  @override
  Stream<List<HomeworkReadModel>> loadMostRecentHomeworks(
      int numberOfHomeworks) {
    return _completedHomeworksSubject.map((homeworks) {
      if (homeworks.length < numberOfHomeworks) return homeworks;
      return homeworks.sublist(0, numberOfHomeworks);
    });
  }
}
