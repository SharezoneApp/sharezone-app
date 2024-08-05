// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/firebase/src/firestore_student_api.dart';

import 'firestore_teacher_and_parents_homework_page_api.dart';
import 'teacher_homework_transformation.dart';

HomeworkPageApi createDefaultFirestoreRepositories(
    CollectionReference homeworkCollection,
    String uid,
    CourseDataRetreiver getCourseData) {
  final studentApi = FirestoreStudentHomeworkApi(
    uid: uid,
    homeworkCollection: homeworkCollection,
    homeworkTransformer: HomeworkTransformer(uid, getCourseData: getCourseData),
  );

  final teacherAndParentApi = FirestoreTeacherAndParentsHomeworkPageApi(
    homeworkCollection,
    uid,
    TeacherHomeworkTransformer(uid, getCourseData: getCourseData),
  );

  return HomeworkPageApi(
    students: studentApi,
    teachersAndParents: teacherAndParentApi,
  );
}
