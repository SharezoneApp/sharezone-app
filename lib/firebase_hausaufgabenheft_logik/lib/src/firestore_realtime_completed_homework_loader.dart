// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_transformation.dart';
import 'realtime_completed_homework_loader.dart';

class FirestoreRealtimeCompletedHomeworkLoader
    extends RealtimeCompletedHomeworkLoader {
  final CollectionReference _homeworkCollection;
  final String _userId;
  final HomeworkTransformer _homeworkTransformer;

  FirestoreRealtimeCompletedHomeworkLoader(
      this._homeworkCollection, this._userId, this._homeworkTransformer);

  @override
  Stream<List<HomeworkReadModel>> loadMostRecentHomeworks(
      int numberOfHomeworks) {
    return _homeworkCollection
        .where('assignedUserArrays.completedStudentUids',
            arrayContains: _userId)
        .orderBy('createdOn', descending: true)
        .limit(numberOfHomeworks)
        .snapshots()
        .transform(_homeworkTransformer);
  }
}
