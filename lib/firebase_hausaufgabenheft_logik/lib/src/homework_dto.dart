// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';

class HomeworkDto {
  final String id;

  final DocumentReference? courseReference;
  final String courseID;
  final String subject;
  final String subjectAbbreviation;
  final String courseName;

  final DocumentReference? authorReference;
  final String authorID;
  final String? authorName;

  final String title;
  final String description;
  final DateTime todoUntil;
  final DateTime? createdOn;
  final List<String> attachments;
  final bool private;
  final bool withSubmissions;
  final List<String> submitters;
  final Map<String, bool?> forUsers;
  final bool sendNotification;
  final String? latestEditor;
  final AssignedUserArrays assignedUserArrays;

  bool get hasAttachments => attachments.isNotEmpty;

  /// Falls ohne Abgaben: Ob die UID in ForUsers mit true oder in
  /// completedStudentArrays ist.
  /// Falls mit Abgaben: Ob die UID in submitters ist.
  /// So eine Methode sollte an sich am besten nicht in ein Dto, aber bis wir
  /// eine richtige "Homework"-Klasse haben, ist es halt so.
  bool isDoneBy(String userId) {
    if (withSubmissions) {
      return submitters.contains(userId);
    } else {
      if (forUsers.isEmpty) return false;
      final id = forUsers[userId];
      if (id != null && id == true) {
        return true;
      }
      if (assignedUserArrays.completedStudentUids.isEmpty) return false;
      return assignedUserArrays.completedStudentUids.contains(userId);
    }
  }

  @override
  String toString() {
    return """
    Homework(
      id: $id,
      - DomainData:
      title: $title,
      description: $description,
      todoUntil: $todoUntil,
      createdOn: $createdOn,
      attachements: $attachments,
      private: $private,
      withSubmissions: $withSubmissions,
      forUsers: $forUsers,
      - Firestore Data:
      courseReference: $courseReference,
      courseId: $courseID,
      subject: $subject,
      subjectAbbreviation: $subjectAbbreviation
      courseName: $courseName,
      authorReference: $authorReference,
      authorId: $authorID,
      submitters: $submitters,
      authorName: $authorName,
      sendNotification: $sendNotification,
      assignedUserArrays: $assignedUserArrays,
    """;
  }

  HomeworkDto._({
    required this.id,
    required this.courseReference,
    required this.courseID,
    required this.subject,
    required this.subjectAbbreviation,
    required this.courseName,
    required this.authorReference,
    required this.authorID,
    required this.authorName,
    required this.title,
    required this.description,
    required this.todoUntil,
    required this.createdOn,
    required this.attachments,
    required this.private,
    required this.withSubmissions,
    required this.submitters,
    required this.forUsers,
    required this.sendNotification,
    required this.latestEditor,
    required this.assignedUserArrays,
  });

  factory HomeworkDto.create({
    DocumentReference? courseReference,
    required String courseID,
  }) {
    return HomeworkDto._(
      id: "",
      courseReference: courseReference,
      courseID: courseID,
      subject: "",
      subjectAbbreviation: "",
      courseName: "",
      authorReference: null,
      authorID: "",
      authorName: "",
      title: "",
      description: "",
      withSubmissions: false,
      submitters: [],
      todoUntil: DateTime.now(),
      createdOn: null,
      attachments: [],
      private: false,
      forUsers: {},
      sendNotification: false,
      latestEditor: null,
      assignedUserArrays: AssignedUserArrays.empty(),
    );
  }

  factory HomeworkDto.fromData(Map<String, dynamic> data,
      {required String id}) {
    return HomeworkDto._(
      id: id,
      courseReference: data['courseReference'],
      courseID: data['courseID'],
      subject: data['subject'],
      subjectAbbreviation: data['subjectAbbreviation'],
      courseName: data['courseName'],
      authorReference: data['authorReference'],
      authorID: data['authorID'],
      authorName: data['authorName'],
      title: data['title'],
      description: data['description'],
      todoUntil: dateTimeFromTimestamp(data['todoUntil']),
      createdOn: dateTimeFromTimestampOrNull(data['createdOn']),
      attachments: decodeList(data['attachments'], (it) => it),
      private: data['private'],
      withSubmissions: data['withSubmissions'] ?? false,
      submitters: decodeList(data['submitters'], (it) => it),
      forUsers: decodeMap(data['forUsers'], (key, value) => value),
      sendNotification: data['sendNotification'] ?? false,
      latestEditor: data['latestEditor'],
      assignedUserArrays: AssignedUserArrays.fromData(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseReference': courseReference,
      'courseID': courseID,
      'subject': subject,
      'subjectAbbreviation': subjectAbbreviation,
      'courseName': courseName,
      'authorReference': authorReference,
      'authorID': authorID,
      'authorName': authorName,
      'title': title,
      'withSubmissions': withSubmissions,
      'description': description,
      'todoUntil': Timestamp.fromDate(todoUntil),
      if (createdOn == null) 'createdOn': FieldValue.serverTimestamp(),
      'attachments': attachments,
      'private': private,
      'forUsers': forUsers,
      'sendNotification': sendNotification,
      'latestEditor': latestEditor,
      'assignedUserArrays': assignedUserArrays.toJson(),
    };
  }

  HomeworkDto copyWith(
      {String? id,
      DocumentReference? courseReference,
      String? courseID,
      String? subject,
      String? subjectAbbreviation,
      String? courseName,
      DocumentReference? authorReference,
      String? authorID,
      String? authorName,
      String? title,
      String? description,
      DateTime? todoUntil,
      DateTime? createdOn,
      List<String>? attachments,
      List<String>? submitters,
      bool? withSubmissions,
      bool? private,
      Map<String, bool>? forUsers,
      bool? sendNotification,
      String? latestEditor,
      AssignedUserArrays? assignedUserArrays}) {
    return HomeworkDto._(
      id: id ?? this.id,
      courseReference: courseReference ?? this.courseReference,
      courseID: courseID ?? this.courseID,
      subject: subject ?? this.subject,
      subjectAbbreviation: subjectAbbreviation ?? this.subjectAbbreviation,
      courseName: courseName ?? this.courseName,
      authorReference: authorReference ?? this.authorReference,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      description: description ?? this.description,
      todoUntil: todoUntil ?? this.todoUntil,
      createdOn: createdOn ?? this.createdOn,
      attachments: attachments ?? this.attachments,
      private: private ?? this.private,
      withSubmissions: withSubmissions ?? this.withSubmissions,
      submitters: submitters ?? this.submitters,
      forUsers: forUsers ?? this.forUsers,
      sendNotification: sendNotification ?? this.sendNotification,
      latestEditor: latestEditor ?? this.latestEditor,
      assignedUserArrays: assignedUserArrays ?? this.assignedUserArrays,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is HomeworkDto &&
        other.id == id &&
        other.courseReference == courseReference &&
        other.courseID == courseID &&
        other.subject == subject &&
        other.subjectAbbreviation == subjectAbbreviation &&
        other.courseName == courseName &&
        other.authorReference == authorReference &&
        other.authorID == authorID &&
        other.authorName == authorName &&
        other.title == title &&
        other.description == description &&
        other.todoUntil == todoUntil &&
        other.createdOn == createdOn &&
        collectionEquals(other.attachments, attachments) &&
        other.private == private &&
        other.withSubmissions == withSubmissions &&
        collectionEquals(other.submitters, submitters) &&
        collectionEquals(other.forUsers, forUsers) &&
        other.sendNotification == sendNotification &&
        other.latestEditor == latestEditor &&
        other.assignedUserArrays == assignedUserArrays;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseReference.hashCode ^
        courseID.hashCode ^
        subject.hashCode ^
        subjectAbbreviation.hashCode ^
        courseName.hashCode ^
        authorReference.hashCode ^
        authorID.hashCode ^
        authorName.hashCode ^
        title.hashCode ^
        description.hashCode ^
        todoUntil.hashCode ^
        createdOn.hashCode ^
        attachments.hashCode ^
        private.hashCode ^
        withSubmissions.hashCode ^
        submitters.hashCode ^
        forUsers.hashCode ^
        sendNotification.hashCode ^
        latestEditor.hashCode ^
        assignedUserArrays.hashCode;
  }
}

class AssignedUserArrays {
  final List<String> allAssignedUids;
  final List<String> completedStudentUids;
  final List<String> openStudentUids;

  AssignedUserArrays({
    required this.allAssignedUids,
    required this.openStudentUids,
    required this.completedStudentUids,
  });

  factory AssignedUserArrays.fromData(Map<String, dynamic> data) {
    if (data['assignedUserArrays'] == null) return AssignedUserArrays.empty();
    final map = decodeMap(data['assignedUserArrays'], (key, value) => value);
    return AssignedUserArrays(
      allAssignedUids: decodeList(map['allAssignedUids'], (it) => it),
      openStudentUids: decodeList(map['openStudentUids'], (it) => it),
      completedStudentUids: decodeList(map['completedStudentUids'], (it) => it),
    );
  }

  factory AssignedUserArrays.empty() {
    return AssignedUserArrays(
      allAssignedUids: [],
      openStudentUids: [],
      completedStudentUids: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allAssignedUids': allAssignedUids,
      'openStudentUids': openStudentUids,
      'completedStudentUids': completedStudentUids,
    };
  }
}
