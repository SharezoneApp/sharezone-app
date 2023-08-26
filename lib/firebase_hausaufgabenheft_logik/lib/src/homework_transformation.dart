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
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_dto.dart';

typedef CourseColorRetriever = FutureOr<int> Function(String courseId);

class HomeworkTransformer extends StreamTransformerBase<
    QuerySnapshot<Map<String, dynamic>>, List<HomeworkReadModel>> {
  final String userId;
  final CourseColorRetriever getCourseColorHexValue;

  HomeworkTransformer(this.userId, {required this.getCourseColorHexValue});

  @override
  Stream<List<HomeworkReadModel>> bind(Stream<QuerySnapshot> stream) {
    return stream.asyncMap(querySnapshotToHomeworks);
  }

  Future<List<HomeworkReadModel>> querySnapshotToHomeworks(
      QuerySnapshot querySnapshot) async {
    final homeworks = <HomeworkReadModel>[];
    for (final document in querySnapshot.docs) {
      final homework = await tryToConvertToHomework(document, userId,
          getCourseColorHexValue: getCourseColorHexValue);
      if (homework != null) {
        homeworks.add(homework);
      }
    }
    return homeworks;
  }
}

Future<HomeworkReadModel?> tryToConvertToHomework(
    DocumentSnapshot documentSnapshot, String uid,
    {CourseColorRetriever? getCourseColorHexValue}) async {
  HomeworkReadModel? converted;
  try {
    final homework = HomeworkDto.fromData(
        documentSnapshot.data() as Map<String, dynamic>,
        id: documentSnapshot.id);

    int? courseColorHex;
    if (getCourseColorHexValue != null) {
      courseColorHex = await getCourseColorHexValue(homework.courseID);
    }
    Subject subject;
    if (courseColorHex != null) {
      subject = Subject(homework.subject, color: Color(courseColorHex));
    } else {
      subject = Subject(homework.subject);
    }

    converted = HomeworkReadModel(
      id: HomeworkId(homework.id),
      todoDate: homework.todoUntil,
      status: homework.isDoneBy(uid)
          ? CompletionStatus.completed
          : CompletionStatus.open,
      subject: subject,
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
