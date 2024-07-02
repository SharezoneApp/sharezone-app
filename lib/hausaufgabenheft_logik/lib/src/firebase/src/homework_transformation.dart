// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'teacher_homework_transformation.dart';

class HomeworkTransformer extends StreamTransformerBase<
    QuerySnapshot<Map<String, dynamic>>, IList<StudentHomeworkReadModel>> {
  final String userId;
  final CourseDataRetreiver getCourseData;

  HomeworkTransformer(this.userId, {required this.getCourseData});

  @override
  Stream<IList<StudentHomeworkReadModel>> bind(Stream<QuerySnapshot> stream) {
    return stream.asyncMap(querySnapshotToHomeworks);
  }

  Future<IList<StudentHomeworkReadModel>> querySnapshotToHomeworks(
      QuerySnapshot querySnapshot) async {
    IList<StudentHomeworkReadModel> homeworks = const IListConst([]);
    for (final document in querySnapshot.docs) {
      final homework = await tryToConvertToHomework(document, userId,
          getCourseData: getCourseData);
      if (homework != null) {
        homeworks = homeworks.add(homework);
      }
    }
    return homeworks;
  }
}

Future<StudentHomeworkReadModel?> tryToConvertToHomework(
    DocumentSnapshot documentSnapshot, String uid,
    {required CourseDataRetreiver getCourseData}) async {
  StudentHomeworkReadModel? converted;
  try {
    final homework = HomeworkDto.fromData(
        documentSnapshot.data() as Map<String, dynamic>,
        id: documentSnapshot.id);

    final courseId = CourseId(homework.courseID);
    final data = await getCourseData(CourseId(homework.courseID));

    converted = StudentHomeworkReadModel(
      id: HomeworkId(homework.id),
      courseId: courseId,
      todoDate: homework.todoUntil,
      status: homework.isDoneBy(uid)
          ? CompletionStatus.completed
          : CompletionStatus.open,
      subject: Subject(
        homework.subject,
        color: Color(data.colorHexValue),
        abbreviation: homework.subjectAbbreviation,
      ),
      withSubmissions: homework.withSubmissions,
      title: Title(homework.title),
    );
  } catch (e, s) {
    final errorMessage = """
    Could not convert a document into a homework object.
    Homework document id: ${documentSnapshot.id}
    User id: $uid
    Error: $e
    Stacktrace: $s
    """;
    log(errorMessage, error: e, stackTrace: s);
  }

  return converted;
}
