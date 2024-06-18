// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    hide tryToConvertToHomework;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

import 'teacher_homework_transformation.dart';

class TeacherFirestoreHomeworkDataSource
    extends HomeworkDataSource<TeacherHomeworkReadModel> {
  final CollectionReference _homeworkCollection;
  final String uid;
  final LazyLoadingController<TeacherHomeworkReadModel> Function(
      int nrOfInitialHomeworksToLoad) createLazyLoadingController;
  final TeacherHomeworkTransformer _homeworkTransformer;

  TeacherFirestoreHomeworkDataSource(this._homeworkCollection, this.uid,
      this.createLazyLoadingController, this._homeworkTransformer);

  @override
  Stream<IList<TeacherHomeworkReadModel>> get openHomeworks {
    final startOfThisDay = clock.now().copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

    return _homeworkCollection
        .where("assignedUserArrays.allAssignedUids", arrayContains: uid)
        .where("todoUntil", isGreaterThanOrEqualTo: startOfThisDay)
        .snapshots()
        .transform(_homeworkTransformer);
  }

  Future<TeacherHomeworkReadModel?> findById(HomeworkId id) async {
    final document = await _homeworkCollection.doc(id.toString()).get();
    final homework = await tryToConvertToHomework(document, uid);
    return homework;
  }

  // TODO: Doesnt make sense for a teacher
  Future<IList<HomeworkId>> getCurrentOpenOverdueHomeworkIds() async {
    final open = await openHomeworks.first;
    final overdue = open
        .where((homeworks) => homeworks.isOverdueRelativeTo(Date.now()))
        .toList();
    final overdueIds = overdue.map((hws) => hws.id).toIList();
    return overdueIds;
  }

  @override
  LazyLoadingController<TeacherHomeworkReadModel>
      getLazyLoadingCompletedHomeworksController(
          int nrOfInitialHomeworkToLoad) {
    return createLazyLoadingController(nrOfInitialHomeworkToLoad);
  }
}
