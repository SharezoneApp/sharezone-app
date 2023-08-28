// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone/pages/homework/homework_details/homework_details_view.dart';
import 'package:sharezone/pages/homework/homework_details/submissions/submission_permissions.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:user/user.dart';

import '../homework_permissions.dart';

class HomeworkDetailsViewFactory implements BlocBase {
  final String uid;
  final CourseGateway courseGateway;
  final FileSharingGateway fileSharingGateway;
  final Stream<TypeOfUser> typeOfUserStream;
  final SubscriptionService subscriptionService;
  late SubmissionPermissions _permissions;

  HomeworkDetailsViewFactory({
    required this.uid,
    required this.courseGateway,
    required this.fileSharingGateway,
    required this.typeOfUserStream,
    required this.subscriptionService,
  }) {
    _permissions = SubmissionPermissions(typeOfUserStream, courseGateway);
  }

  Future<HomeworkDetailsView> fromStudentHomeworkView(
      StudentHomeworkView studentHomeworkView) async {
    final typeOfUser = await typeOfUserStream.first;
    return HomeworkDetailsView(
      title: studentHomeworkView.title,
      courseName: studentHomeworkView.subject,
      todoUntil: studentHomeworkView.todoDate,
      attachmentStream: Stream.value([]),
      attachmentIDs: [],
      authorName: '',
      hasAttachments: false,
      hasPermission: false,
      id: studentHomeworkView.id,
      isDone: studentHomeworkView.isCompleted,
      description: '',
      isPrivate: false,
      courseID: '',
      homework: HomeworkDto.create(courseID: ''),
      withSubmissions: studentHomeworkView.withSubmissions,
      hasSubmitted: studentHomeworkView.isCompleted,
      nrOfSubmissions: 0,
      typeOfUser: typeOfUser,
      hasPermissionToViewSubmissions: false,
      nrOfCompletedStudents: 0,
      hasPermissionsToViewDoneByList: false,
      hasTeacherSubmissionsUnlocked: false,
    );
  }

  Future<HomeworkDetailsView> fromHomeworkDb(HomeworkDto homework) async {
    final hasSubmitted = homework.submitters.contains(uid);
    final typeOfUser = await typeOfUserStream.first;
    return HomeworkDetailsView(
      isDone: homework.forUsers[uid]! || hasSubmitted,
      authorName: homework.authorName ?? "-",
      courseName: homework.courseName,
      todoUntil: _formatTodoUntil(homework.todoUntil, homework.withSubmissions),
      id: homework.id,
      title: homework.title,
      description: homework.description,
      hasAttachments: homework.attachments.toList().isNotEmpty,
      attachmentIDs: homework.attachments.toList(),
      attachmentStream: fileSharingGateway.cloudFilesGateway
          .filesStreamAttachment(homework.courseID, homework.id),
      hasPermission: hasPermissionToManageHomeworks(
        courseGateway.getRoleFromCourseNoSync(homework.courseID)!,
        _isAuthor(homework.authorID),
      ),
      homework: homework,
      isPrivate: homework.private,
      courseID: homework.courseID,
      hasSubmitted: hasSubmitted,
      nrOfSubmissions: homework.submitters.length,
      typeOfUser: typeOfUser,
      withSubmissions: homework.withSubmissions,
      nrOfCompletedStudents:
          homework.assignedUserArrays.completedStudentUids.length,
      hasPermissionToViewSubmissions:
          await _permissions.isAllowedToViewSubmittedPermissions(homework),
      hasPermissionsToViewDoneByList:
          typeOfUser == TypeOfUser.teacher && _isAdmin(homework.courseID),
      hasTeacherSubmissionsUnlocked: subscriptionService
          .hasFeatureUnlocked(SharezonePlusFeature.submissionsList),
    );
  }

  bool _isAdmin(String courseID) {
    final role =
        courseGateway.getRoleFromCourseNoSync(courseID) ?? MemberRole.standard;
    return role == MemberRole.admin || role == MemberRole.owner;
  }

  bool _isAuthor(String authorID) {
    return authorID == uid;
  }

  static String _formatTodoUntil(DateTime todoUntil, bool withSubmissions) {
    final dateString = DateFormat.yMMMd().format(todoUntil);
    if (!withSubmissions) return dateString;
    return '$dateString - ${todoUntil.hour}:${_getMinute(todoUntil.minute)} Uhr';
  }

  static String _getMinute(int minute) {
    if (minute >= 10) return minute.toString();
    return '0$minute';
  }

  @override
  void dispose() {}
}
