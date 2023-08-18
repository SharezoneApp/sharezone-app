// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'homework_transformation.dart';

class FirestoreHomeworkDataSource extends HomeworkDataSource {
  final CollectionReference _homeworkCollection;
  final String uid;
  final LazyLoadingController Function(int nrOfInitialHomeworksToLoad)
      createLazyLoadingController;
  final HomeworkTransformer _homeworkTransformer;

  FirestoreHomeworkDataSource(this._homeworkCollection, this.uid,
      this.createLazyLoadingController, this._homeworkTransformer);

  @override
  Stream<List<HomeworkReadModel>> get openHomeworks {
    return _homeworkCollection
        .where("assignedUserArrays.openStudentUids", arrayContains: uid)
        .snapshots()
        .transform(_homeworkTransformer);
  }

  Future<HomeworkReadModel?> findById(HomeworkId id) async {
    final document = await _homeworkCollection.doc(id.toString()).get();
    final homework = await tryToConvertToHomework(document, uid);
    return homework;
  }

  Future<List<HomeworkId>> getCurrentOpenOverdueHomeworkIds() async {
    final open = await openHomeworks.first;
    final overdue = open
        .where((homeworks) => homeworks.isOverdueRelativeTo(Date.now()))
        .toList();
    final overdueIds = overdue.map((hws) => hws.id).toList();
    return overdueIds;
  }

  @override
  LazyLoadingController getLazyLoadingCompletedHomeworksController(
      int nrOfInitialHomeworkToLoad) {
    return createLazyLoadingController(nrOfInitialHomeworkToLoad);
  }
}
