// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/homework/analytics/homework_analytics.dart';
import 'package:sharezone/util/api/homework_api.dart';
import 'package:sharezone_common/references.dart';
import 'package:user/user.dart';

import 'user_has_completed_homework_view.dart';

class HomeworkCompletionUserListBloc extends BlocBase {
  final HomeworkId _id;
  final HomeworkGateway _gateway;
  final CollectionReference _courseRef;
  final HomeworkAnalytics _analyitcs;

  // This is a workaround as the [HomeworkCompletionUserListBlocFactory] can't
  // use an async method when creating the bloc, as the UI needs this bloc right
  // away.
  // A better solution would be to cache already loaded homeworks (or at least
  // the courseId that corresponds to a homework id) so that we can access the
  // course id synchronously.
  // As this would need a rework in many different places we use this
  // workaround.
  final Future<CourseId> _courseIdFuture;
  bool _loadedCourseId = false;
  CourseId _courseId;

  HomeworkCompletionUserListBloc(
    this._id,
    this._gateway,
    this._courseRef,
    this._analyitcs,
    Future<CourseId> courseIdFuture,
  ) : _courseIdFuture = courseIdFuture;

  Future<void> _loadCourseId() async {
    _courseId = await _courseIdFuture;
    _loadedCourseId = true;
  }

  Stream<List<UserHasCompletedHomeworkView>> get userViews {
    return _gateway.singleHomeworkStream(_id.id).asyncMap(_mapToViews);
  }

  Future<List<UserHasCompletedHomeworkView>> _mapToViews(
      HomeworkDto item) async {
    final views = <UserHasCompletedHomeworkView>[];

    // Undone Students
    for (final studentId in item.assignedUserArrays.openStudentUids) {
      final user = await _getUser(studentId);
      // Aufgrund eines Fehlers in den CloudFunctions, werden Lehrkräfte & Eltern
      // ebenfalls in das openStudentUids-Array hinzugefügt. Deswegen sollte zusätzlich
      // überprüft werden, ob der User wirklich ein Schüler ist.
      // Ticket zum Bug: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/963
      if (user.isStudent) {
        views.add(user.toView(hasDone: false));
      }
    }

    // Completed Students
    for (final studentId in item.assignedUserArrays.completedStudentUids) {
      final user = await _getUser(studentId);
      // Aufgrund eines Fehlers in den CloudFunctions, werden Lehrkräfte & Eltern
      // ebenfalls in das openStudentUids-Array hinzugefügt. Deswegen sollte zusätzlich
      // überprüft werden, ob der User wirklich ein Schüler ist.
      // Ticket zum Bug: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/963
      if (user.isStudent) {
        views.add(user.toView(hasDone: true));
      }
    }

    return views.sortAlphabetically();
  }

  Future<MemberData> _getUser(String userId) async {
    if (!_loadedCourseId) {
      await _loadCourseId();
    }
    final doc = await _courseRef
        .doc('$_courseId')
        .collection(CollectionNames.members)
        .doc(userId)
        .get();
    return MemberData.fromData(doc.data(), id: userId);
  }

  void logOpenHomeworkDoneByUsersList() {
    _analyitcs.logOpenHomeworkDoneByUsersList();
  }

  @override
  void dispose() {}
}

extension on MemberData {
  UserHasCompletedHomeworkView toView({@required bool hasDone}) {
    return UserHasCompletedHomeworkView(
      uid: '$id',
      name: name,
      hasDone: hasDone,
    );
  }

  bool get isStudent => typeOfUser == TypeOfUser.student;
}

extension on List<UserHasCompletedHomeworkView> {
  List<UserHasCompletedHomeworkView> sortAlphabetically() {
    return this..sort((a, b) => a.name.compareTo(b.name));
  }
}
