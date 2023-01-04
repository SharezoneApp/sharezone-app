// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:sharezone/additional/course_permission.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'comment.dart';
import 'comment_view.dart';
import 'misc.dart';

class CommentViewFactory {
  final CourseGateway courseGateway;
  final String uid;

  const CommentViewFactory({@required this.courseGateway, @required this.uid});

  CommentView fromModel(Comment comment, String courseID) {
    return CommentView(
      avatarAbbreviation: comment.author.abbreviation,
      commentAge: _commentAgeToLocaleString(comment.age),
      content: comment.content,
      likes: comment.score.toString(),
      status: _matchCommentStatus(comment.getCommentStatusOfUser(uid)),
      userName: comment.author.name,
      id: comment.id,
      hasPermissionsToManageComments:
          _hasPermissionsToManageComments(courseID, comment.author.uid),
    );
  }

  bool _hasPermissionsToManageComments(String courseID, String authorID) {
    final myRole = courseGateway.getRoleFromCourseNoSync(courseID);
    return myRole.hasPermission(GroupPermission.administration) ||
        authorID == uid;
  }

  CommentStatus _matchCommentStatus(CommentStatus status) {
    switch (status) {
      case CommentStatus.liked:
        return CommentStatus.liked;
        break;
      case CommentStatus.disliked:
        return CommentStatus.disliked;
        break;
      case CommentStatus.notRated:
        return CommentStatus.notRated;
        break;
      default:
        return CommentStatus.notRated;
    }
  }

  String _commentAgeToLocaleString(CommentAge age) {
    // Damit 'de' als Locale funktioniert, muss vorher das Locale
    // erst mit timeago.setLocaleMessages('de', timeago.DeMessages());
    // hinzugefügt werden - in der main/runApp-Methode.
    return timeago.format(age.writtenOnDateTime, locale: 'de');
  }
}
