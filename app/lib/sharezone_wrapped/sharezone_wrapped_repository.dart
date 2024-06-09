// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:retry/retry.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/util/api/connections_gateway.dart';

class SharezoneWrappedRepository {
  final FirebaseFirestore firestore;
  final ConnectionsGateway connectionsGateway;
  final UserId userId;

  const SharezoneWrappedRepository({
    required this.firestore,
    required this.userId,
    required this.connectionsGateway,
  });

  Future<int?> getTotalAmountOfHomeworks() async {
    return _retry(() async {
      final res = await firestore
          .collection('Homeworks')
          .where('assignedUserArrays.allAssignedUids', arrayContains: '$userId')
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
          .collection('Homeworks')
          .where('courseID', isEqualTo: '$courseId')
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
          .count()
          .get();
      return res.count;
    });
  }

  Future<int?> getAmountOfExamsFor({required CourseId courseId}) async {
    return _retry(() async {
      final res = await firestore
          .collection('Events')
          .where('courseID', isEqualTo: '$courseId')
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
    return connectionsGateway.joinedCoursesPackage.data;
  }

  Future<T> _retry<T>(Future<T> Function() fn) {
    return retry(
      () => fn(),
      maxAttempts: 3,
    );
  }
}
