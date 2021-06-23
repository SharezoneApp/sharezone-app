import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:optional/optional.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_dto.dart';

typedef CourseColorRetreiver = FutureOr<int> Function(String courseId);

class HomeworkTransformer
    extends StreamTransformerBase<QuerySnapshot, List<HomeworkReadModel>> {
  final String userId;
  final CourseColorRetreiver getCourseColorHexValue;

  HomeworkTransformer(this.userId, {this.getCourseColorHexValue});

  @override
  Stream<List<HomeworkReadModel>> bind(Stream<QuerySnapshot> stream) {
    return stream.asyncMap(querySnapshotToHomeworks);
  }

  Future<List<HomeworkReadModel>> querySnapshotToHomeworks(
      QuerySnapshot querySnapshot) async {
    final homeworks = <HomeworkReadModel>[];
    for (final document in querySnapshot.docs) {
      final maybeConverted = await tryToConvertToHomework(document, userId,
          getCourseColorHexValue: getCourseColorHexValue);
      maybeConverted.ifPresent(homeworks.add);
    }
    return homeworks;
  }
}

Future<Optional<HomeworkReadModel>> tryToConvertToHomework(
    DocumentSnapshot documentSnapshot, String uid,
    {CourseColorRetreiver getCourseColorHexValue}) async {
  HomeworkReadModel converted;
  try {
    final homework =
        HomeworkDto.fromData(documentSnapshot.data(), id: documentSnapshot.id);

    int courseColorHex;
    if (getCourseColorHexValue != null &&
        homework?.courseReference?.id != null) {
      courseColorHex =
          await getCourseColorHexValue(homework.courseReference.id);
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
    Homework document id: ${documentSnapshot?.id}
    User id: $uid
    Error: $e
    Stacktrace: $s
    """;
    print(errorMessage);
  }

  return Optional.ofNullable(converted);
}
