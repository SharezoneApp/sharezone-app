// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:retry/retry.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/util/api/connections_gateway.dart';

class SharezoneWrappedRepository {
  final FirebaseFirestore firestore;
  final ConnectionsGateway connectionsGateway;
  final UserId userId;
  final Clock clock;

  const SharezoneWrappedRepository({
    required this.firestore,
    required this.userId,
    required this.connectionsGateway,
    required this.clock,
  });

  /// Returns the minimum date for createdOn to be used in queries because we
  /// only want to consider data from the current school year.
  ///
  /// Using a fixed date for now, because we don't have a school year concept
  /// yet.
  DateTime _minimumCreatedAt() {
    return clock.now().subtract(const Duration(days: 365));
  }

  Future<int?> getTotalAmountOfHomeworks() async {
    return _retry(() async {
      final res = await firestore
          .collection('Homework')
          .where('assignedUserArrays.allAssignedUids', arrayContains: '$userId')
          .where('createdOn', isGreaterThan: _minimumCreatedAt())
          .count()
          .get();
      return res.count;
    });
  }

  Future<int?> getAmountOfHomeworksFor({required CourseId courseId}) async {
    return _retry(() async {
      // Open question: What happens, when there is a homework where the user is
      // not assigned?
      final res = await firestore
          .collection('Homework')
          .where('courseID', isEqualTo: '$courseId')
          .where('assignedUserArrays.allAssignedUids', arrayContains: '$userId')
          .where('createdOn', isGreaterThan: _minimumCreatedAt())
          .count()
          .get();
      return res.count;
    });
  }

  Future<int?> getTotalAmountOfExams() async {
    return _retry(() async {
      final res = await firestore
          .collection('Events')
          .where('users', arrayContains: '$userId')
          .where('eventType', isEqualTo: 'exam')
          // createdOn was added Feb 2024, we can't use it for this year.
          .where('date',
              isGreaterThan: _minimumCreatedAt().toDate().toDateString)
          .count()
          .get();
      return res.count;
    });
  }

  Future<int?> getAmountOfExamsFor({required CourseId courseId}) async {
    return _retry(() async {
      final res = await firestore
          .collection('Events')
          .where('users', arrayContains: '$userId')
          .where('groupID', isEqualTo: '$courseId')
          // createdOn was added Feb 2024, we can't use it for this year.
          .where('date',
              isGreaterThan: _minimumCreatedAt().toDate().toDateString)
          .where('eventType', isEqualTo: 'exam')
          .count()
          .get();
      return res.count;
    });
  }

  Future<List<Lesson>> getLessons() async {
    return _retry(() async {
      // Technical debt: We already load all lessons for the timetable. We could
      // reuse this data here to avoid unnecessary Firestore reads. Haven't done
      // this yet, to move faster.
      final res = await firestore
          .collection('Lessons')
          .where('users', arrayContains: '$userId')
          .get();
      return res.docs.map((e) => Lesson.fromData(e.data(), id: e.id)).toList();
    });
  }

  List<Course> getCourses() {
    return connectionsGateway
            .current()
            ?.courses
            .entries
            .map((e) => e.value.copyWith(id: e.key))
            .toList() ??
        [];
  }

  Future<T> _retry<T>(Future<T> Function() fn) {
    return retry(
      () => fn(),
      maxAttempts: 3,
    );
  }
}
