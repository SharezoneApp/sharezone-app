// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone_common/helper_functions.dart';

class BlackboardItem {
  final String id;

  final DocumentReference? courseReference;
  final String courseName;
  final String subject;
  final String subjectAbbreviation;
  final String latestEditor;

  final String authorID;
  final String authorName;
  final DateTime createdOn;

  final String title;
  final String? text;
  final String? pictureURL;
  final List<String> attachments;
  final bool sendNotification;

  final Map<String, bool> forUsers;

  const BlackboardItem._({
    required this.id,
    required this.courseReference,
    required this.courseName,
    required this.subject,
    required this.subjectAbbreviation,
    required this.latestEditor,
    required this.authorID,
    required this.authorName,
    required this.title,
    required this.text,
    required this.pictureURL,
    required this.createdOn,
    required this.attachments,
    required this.sendNotification,
    required this.forUsers,
  });

  factory BlackboardItem.create({
    required DocumentReference? courseReference,
    required String authorID,
  }) {
    return BlackboardItem._(
      id: "",
      courseReference: courseReference,
      courseName: "",
      subject: "",
      subjectAbbreviation: "",
      latestEditor: "",
      authorID: authorID,
      authorName: "",
      title: "",
      text: null,
      pictureURL: "",
      createdOn: DateTime.now(),
      attachments: [],
      sendNotification: true,
      forUsers: {},
    );
  }

  factory BlackboardItem.fromData(
    Map<String, dynamic> data, {
    required String id,
  }) {
    final authorId = data['authorID'] as String;
    return BlackboardItem._(
      id: id,
      courseReference: data['courseReference'] as DocumentReference,
      courseName: data['courseName'] as String,
      subject: data['subject'] as String,
      subjectAbbreviation: data['subjectAbbreviation'] as String,
      // This attribute was added later on, so there might be some items in the
      // database without it. In that case, we just use the authorId as the
      // latestEditor because back then, the author was the latest editor.
      latestEditor: (data['latestEditor'] as String?) ?? authorId,
      authorID: authorId,
      authorName: data['authorName'] as String,
      title: data['title'] as String,
      text: data['text'] as String?,
      pictureURL: data['pictureURL'] as String?,
      createdOn: ((data['createdOn'] ?? Timestamp.now()) as Timestamp).toDate(),
      attachments: decodeList(data['attachments'], (it) => it as String),
      sendNotification: (data['sendNotification'] as bool?) ?? false,
      forUsers: decodeMap(data['forUsers'], (key, value) => value as bool),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseReference': courseReference,
      'courseName': courseName,
      'subject': subject,
      'subjectAbbreviation': subjectAbbreviation,
      'latestEditor': latestEditor,
      'authorID': authorID,
      'authorName': authorName,
      'title': title,
      'text': text,
      'pictureURL':
          pictureURL == null || pictureURL!.isEmpty ? "null" : pictureURL,
      'createdOn': Timestamp.fromDate(createdOn),
      'attachments': attachments,
      'sendNotification': sendNotification,
      'forUsers': forUsers
    };
  }

  BlackboardItem copyWith({
    String? id,
    DocumentReference? courseReference,
    String? courseName,
    String? subject,
    String? subjectAbbreviation,
    String? latestEditor,
    String? authorID,
    String? authorName,
    String? title,
    String? text,
    String? pictureURL,
    DateTime? createdOn,
    List<String>? attachments,
    bool? sendNotification,
    Map<String, bool>? forUsers,
  }) {
    return BlackboardItem._(
      id: id ?? this.id,
      courseReference: courseReference ?? this.courseReference,
      courseName: courseName ?? this.courseName,
      subject: subject ?? this.subject,
      subjectAbbreviation: subjectAbbreviation ?? this.subjectAbbreviation,
      latestEditor: latestEditor ?? this.latestEditor,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      text: text ?? this.text,
      pictureURL: pictureURL ?? this.pictureURL,
      createdOn: createdOn ?? this.createdOn,
      attachments: attachments ?? this.attachments,
      sendNotification: sendNotification ?? this.sendNotification,
      forUsers: forUsers ?? this.forUsers,
    );
  }
}
