// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

class FirestoreHomeworkCompletionDispatcher
    extends HomeworkCompletionDispatcher {
  final CollectionReference _homeworkCollection;
  final String Function() getCurrentUserId;

  FirestoreHomeworkCompletionDispatcher(
      this._homeworkCollection, this.getCurrentUserId);

  @override
  Future<void> dispatch(HomeworkCompletion homeworkCompletion) async {
    final uid = getCurrentUserId();
    final documentReference =
        _homeworkCollection.doc(homeworkCompletion.homeworkId.toString());
    switch (homeworkCompletion.newCompletionValue) {
      case CompletionStatus.completed:
        documentReference.update({
          'assignedUserArrays.completedStudentUids':
              FieldValue.arrayUnion([uid])
        });
        documentReference.update({
          'assignedUserArrays.openStudentUids': FieldValue.arrayRemove([uid])
        });
        break;
      case CompletionStatus.open:
        documentReference.update({
          'assignedUserArrays.completedStudentUids':
              FieldValue.arrayRemove([uid])
        });
        documentReference.update({
          'assignedUserArrays.openStudentUids': FieldValue.arrayUnion([uid])
        });
        break;
    }
  }
}
