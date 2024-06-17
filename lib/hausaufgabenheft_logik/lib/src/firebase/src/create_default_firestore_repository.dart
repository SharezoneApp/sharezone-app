// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

import 'teacher_firestore_homework_data_source.dart';
import 'teacher_firestore_realtime_completed_homework_loader.dart';
import 'teacher_homework_transformation.dart';

({
  FirestoreHomeworkDataSource student,
  HomeworkDataSource<TeacherHomeworkReadModel> teacher
}) createDefaultFirestoreRepositories(CollectionReference homeworkCollection,
    String uid, CourseColorRetriever getCourseColorFromCourseId) {
  final homeworkLoader = FirestoreRealtimeCompletedHomeworkLoader(
    homeworkCollection,
    uid,
    HomeworkTransformer(uid,
        getCourseColorHexValue: getCourseColorFromCourseId),
  );

  final lazyLoadingControllerFactory =
      RealtimeUpdatingLazyLoadingControllerFactory(homeworkLoader);
  final firestoreHomeworkRepository = FirestoreHomeworkDataSource(
    homeworkCollection,
    uid,
    lazyLoadingControllerFactory.create,
    HomeworkTransformer(uid,
        getCourseColorHexValue: getCourseColorFromCourseId),
  );

  final teacherHomeworkLoader = TeacherFirestoreRealtimeCompletedHomeworkLoader(
    homeworkCollection,
    uid,
    TeacherHomeworkTransformer(uid,
        getCourseColorHexValue: getCourseColorFromCourseId),
  );

  final teacherLazyLoadingControllerFactory =
      RealtimeUpdatingLazyLoadingControllerFactory(teacherHomeworkLoader);
  final firestoreTeacherHomeworkRepository = TeacherFirestoreHomeworkDataSource(
    homeworkCollection,
    uid,
    teacherLazyLoadingControllerFactory.create,
    TeacherHomeworkTransformer(uid,
        getCourseColorHexValue: getCourseColorFromCourseId),
  );

  return (
    student: firestoreHomeworkRepository,
    teacher: firestoreTeacherHomeworkRepository
  );
}
