// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/firebase/src/advanceable_homework_loader.dart';

import 'realtime_updating_lazy_loading_controller.dart';

class FirestoreStudentHomeworkApi extends StudentHomeworkPageApi
    implements AdvanceableHomeworkLoader<StudentHomeworkReadModel> {
  final CollectionReference homeworkCollection;
  final String uid;
  final HomeworkTransformer homeworkTransformer;

  FirestoreStudentHomeworkApi({
    required this.homeworkCollection,
    required this.uid,
    required this.homeworkTransformer,
  });

  @override
  Future<void> completeHomework(
      HomeworkId homeworkId, CompletionStatus newCompletionStatus) async {
    final documentReference = homeworkCollection.doc(homeworkId.toString());
    switch (newCompletionStatus) {
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

  @override
  LazyLoadingController<StudentHomeworkReadModel>
      getLazyLoadingCompletedHomeworksController(
          int nrOfInitialHomeworkToLoad) {
    return RealtimeUpdatingLazyLoadingController<StudentHomeworkReadModel>(this,
        initialNumberOfHomeworksToLoad: nrOfInitialHomeworkToLoad);
  }

  @override
  Stream<IList<StudentHomeworkReadModel>> loadHomeworks(int numberOfHomeworks) {
    return homeworkCollection
        .where('assignedUserArrays.completedStudentUids', arrayContains: uid)
        .orderBy('createdOn', descending: true)
        .limit(numberOfHomeworks)
        .snapshots()
        .transform(homeworkTransformer);
  }

  @override
  Future<IList<HomeworkId>> getOpenOverdueHomeworkIds() async {
    final open = await openHomeworks.first;
    final overdue = open
        .where((homeworks) => homeworks.isOverdueRelativeTo(Date.now()))
        .toList();
    final overdueIds = overdue.map((hws) => hws.id).toIList();
    return overdueIds;
  }

  @override
  Stream<IList<StudentHomeworkReadModel>> get openHomeworks {
    return homeworkCollection
        .where("assignedUserArrays.openStudentUids", arrayContains: uid)
        .snapshots()
        .transform(homeworkTransformer);
  }
}
