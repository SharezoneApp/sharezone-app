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
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/firebase/src/advanceable_homework_loader.dart';
import 'package:hausaufgabenheft_logik/src/firebase/src/teacher_homework_transformation.dart';

import 'realtime_updating_lazy_loading_controller.dart';

class FirestoreTeacherAndParentsHomeworkPageApi
    extends TeacherAndParentHomeworkPageApi
    implements AdvanceableHomeworkLoader<TeacherHomeworkReadModel> {
  final CollectionReference _homeworkCollection;
  final String uid;
  final TeacherHomeworkTransformer _homeworkTransformer;

  FirestoreTeacherAndParentsHomeworkPageApi(
      this._homeworkCollection, this.uid, this._homeworkTransformer);

  @override
  LazyLoadingController<TeacherHomeworkReadModel>
      getLazyLoadingArchivedHomeworksController(int nrOfInitialHomeworkToLoad) {
    return RealtimeUpdatingLazyLoadingController<TeacherHomeworkReadModel>(this,
        initialNumberOfHomeworksToLoad: nrOfInitialHomeworkToLoad);
  }

  @override
  Stream<IList<TeacherHomeworkReadModel>> loadHomeworks(int numberOfHomeworks) {
    return _homeworkCollection
        .where('assignedUserArrays.allAssignedUids', arrayContains: uid)
        .orderBy('createdOn', descending: true)
        .limit(numberOfHomeworks)
        .snapshots()
        .transform(_homeworkTransformer);
  }

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
}
