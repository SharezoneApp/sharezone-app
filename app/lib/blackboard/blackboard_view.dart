// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/groups/group_permission.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/theme.dart';

import 'blackboard_item.dart';

class BlackboardView {
  final String title;
  final String text;
  final String previewText;
  final String id;
  final String pictureURL;
  final String courseName;
  final String courseID;
  final String createdOnText;
  final String authorName;
  final int readPercent;
  final Color readPerecentColor, courseNameColor;
  final bool isAuthor, hasAttachments, hasPhoto, hasPermissionToEdit, isRead;
  final BlackboardItem item;
  final List<String> attachmentIDs;

  BlackboardView({
    @required this.item,
    @required this.title,
    @required this.text,
    @required this.previewText,
    @required this.authorName,
    @required this.courseName,
    @required this.courseNameColor,
    @required this.courseID,
    @required this.readPercent,
    @required this.createdOnText,
    @required this.readPerecentColor,
    @required this.isAuthor,
    @required this.hasPhoto,
    @required this.hasAttachments,
    @required this.hasPermissionToEdit,
    @required this.pictureURL,
    @required this.id,
    @required this.attachmentIDs,
    @required this.isRead,
  });

  factory BlackboardView.empty({String id}) {
    return BlackboardView(
      attachmentIDs: [],
      authorName: '',
      courseID: '',
      courseName: '',
      courseNameColor: primaryColor,
      createdOnText: '',
      hasAttachments: false,
      hasPermissionToEdit: false,
      previewText: '',
      hasPhoto: false,
      id: id ?? 'PlaceholderId',
      isAuthor: false,
      isRead: false,
      item: BlackboardItem.create(courseReference: null, authorReference: null),
      pictureURL: '',
      readPercent: 0,
      readPerecentColor: Colors.green,
      text: '',
      title: '',
    );
  }

  factory BlackboardView.fromBlackboardItem(
      BlackboardItem item, String uid, CourseGateway courseGateway) {
    final readPercent = _calculateReadPercent(item);
    final isAuthor = _isAuthor(item, uid);
    final courseID = item.courseReference.id;
    return BlackboardView(
      id: item.id,
      item: item,
      title: item.title,
      previewText: _getTextPreview(item.text),
      text: item.text,
      pictureURL: item.pictureURL,
      readPercent: readPercent,
      authorName: item.authorName,
      createdOnText: _createdOnAsString(item.createdOn),
      courseName: item.courseName,
      courseNameColor: _getCourseColor(courseID, courseGateway),
      courseID: courseID,
      readPerecentColor: _getReadByColor(readPercent),
      hasAttachments: _hasAttachments(item),
      isAuthor: isAuthor,
      hasPhoto: _hasPhoto(item.pictureURL),
      hasPermissionToEdit:
          _hasPermissionToEdit(isAuthor, courseID, courseGateway),
      attachmentIDs: item.attachments,
      isRead: _isRead(item, uid),
    );
  }

  /// Shorts [fullText] to 140 characters and adds "..." to the end, if [fullText]
  /// is longer than 140 characters.
  static String _getTextPreview(String fullText) {
    if (isEmptyOrNull(fullText)) return '';
    if (fullText.characters.length <= 140) return fullText;
    return '${fullText.characters.take(140)}...';
  }

  static bool _isRead(BlackboardItem item, String uid) => item.forUsers[uid];

  static Color _getCourseColor(String courseID, CourseGateway courseGateway) {
    final course = courseGateway.getCourse(courseID) ?? Course.create();
    final color = course.getDesign().color;
    return color;
  }

  static String _createdOnAsString(DateTime createdOn) {
    return DateFormat("d.M.y").format(createdOn);
  }

  static bool _hasPermissionToEdit(
      bool isAuthor, String courseID, CourseGateway courseGateway) {
    if (isAuthor) return true;
    final isAdmin = isUserAdminOrOwnerOfGroup(
        courseGateway.getRoleFromCourseNoSync(courseID));
    if (isAdmin) return true;
    return false;
  }

  static bool _hasPhoto(String pictureURL) =>
      !(pictureURL == null || pictureURL == "null");

  static int _calculateReadPercent(BlackboardItem item) {
    int numberOfReads = 0;
    final userSize = item.forUsers.length - 1;

    if (userSize == 0) return 100;

    item.forUsers.forEach((k, v) {
      if (k != item.authorReference.id && v == true) {
        numberOfReads++;
      }
    });

    if (userSize == 0) return 1;

    final percent = (numberOfReads / userSize) * 100;
    return percent.round();
  }

  static Color _getReadByColor(int percent) {
    if (percent <= 25) return Colors.red;
    if (percent > 25 && percent < 95) return Colors.orange;
    return Colors.lightGreen;
  }

  static bool _isAuthor(BlackboardItem item, String uid) =>
      item.authorID == uid;

  static bool _hasAttachments(BlackboardItem item) {
    return item.attachments != null && item.attachments.isNotEmpty;
  }
}
