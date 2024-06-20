// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

class TeacherHomeworkTransformer extends StreamTransformerBase<
    QuerySnapshot<Map<String, dynamic>>, IList<TeacherHomeworkReadModel>> {
  final String userId;
  final CourseColorRetriever getCourseColorHexValue;

  TeacherHomeworkTransformer(this.userId,
      {required this.getCourseColorHexValue});

  @override
  Stream<IList<TeacherHomeworkReadModel>> bind(Stream<QuerySnapshot> stream) {
    return stream.asyncMap(querySnapshotToHomeworks);
  }

  Future<IList<TeacherHomeworkReadModel>> querySnapshotToHomeworks(
      QuerySnapshot querySnapshot) async {
    IList<TeacherHomeworkReadModel> homeworks = const IListConst([]);
    for (final document in querySnapshot.docs) {
      final homework = await tryToConvertToHomework(document, userId,
          getCourseColorHexValue: getCourseColorHexValue);
      if (homework != null) {
        homeworks = homeworks.add(homework);
      }
    }
    return homeworks;
  }
}

Future<TeacherHomeworkReadModel?> tryToConvertToHomework(
    DocumentSnapshot documentSnapshot, String uid,
    {CourseColorRetriever? getCourseColorHexValue}) async {
  TeacherHomeworkReadModel? converted;
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
      subject = Subject(
        homework.subject,
        color: Color(courseColorHex),
        abbreviation: homework.subjectAbbreviation,
      );
    } else {
      subject = Subject(
        homework.subject,
        abbreviation: homework.subjectAbbreviation,
      );
    }

    final startOfThisDay = clock.now().copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );

    converted = TeacherHomeworkReadModel(
      id: HomeworkId(homework.id),
      todoDate: homework.todoUntil,
      status: homework.todoUntil.isBefore(startOfThisDay)
          ? ArchivalStatus.archived
          : ArchivalStatus.open,
      subject: subject,
      withSubmissions: homework.withSubmissions,
      title: Title(homework.title),
      // TODO: Implement
      canDeleteForEveryone: true,
      canEditForEveryone: true,
      canViewCompletions: true,
      canViewSubmissions: true,
      nrOfStudentsCompleted:
          homework.assignedUserArrays.completedStudentUids.length,
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
