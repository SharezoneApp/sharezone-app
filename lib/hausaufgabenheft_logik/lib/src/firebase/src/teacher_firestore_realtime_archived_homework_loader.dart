// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

import 'advanceable_homework_loader.dart';
import 'teacher_homework_transformation.dart';

class TeacherFirestoreRealtimeArchivedHomeworkLoader
    extends AdvanceableHomeworkLoader<TeacherHomeworkReadModel> {
  final CollectionReference _homeworkCollection;
  final String _userId;
  final TeacherHomeworkTransformer _homeworkTransformer;

  TeacherFirestoreRealtimeArchivedHomeworkLoader(
      this._homeworkCollection, this._userId, this._homeworkTransformer);

  @override
  Stream<IList<TeacherHomeworkReadModel>> loadHomeworks(int numberOfHomeworks) {
    return _homeworkCollection
        .where('assignedUserArrays.allAssignedUids', arrayContains: _userId)
        .orderBy('createdOn', descending: true)
        .limit(numberOfHomeworks)
        .snapshots()
        .transform(_homeworkTransformer);
  }
}
