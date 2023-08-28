// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/comments/comment.dart';
import 'package:sharezone/comments/comment_data_models.dart';
import 'package:sharezone/comments/comment_view.dart';
import 'package:sharezone/comments/comment_view_factory.dart';
import 'package:sharezone/comments/misc.dart';
import 'package:user/user.dart';

import 'comments_analytics.dart';
import 'comments_gateway.dart';

class CommentsBloc extends BlocBase {
  final CommentsGateway _gateway;
  final CommentsLocation _commentsLocation;
  final Stream<AppUser?> _userStream;
  final CommentViewFactory _commentViewFactory;
  final String courseID;
  final CommentsAnalytics _analytics;

  late CommentAuthor _currentAuthorInformation;

  final _commentsSubject = BehaviorSubject<List<CommentView>>();
  final _commentAddSubject = BehaviorSubject<String>();
  final _rateSubject = BehaviorSubject<RateCommentEvent>();
  final _deletionSubject = BehaviorSubject<String>();

  StreamSubscription? _subscription;

  CommentsBloc(this._gateway, this._commentsLocation, this._userStream,
      this._commentViewFactory, this.courseID, this._analytics) {
    _userStream.listen((user) {
      if (user == null) return;
      _currentAuthorInformation = CommentAuthor(
        abbreviation: user.abbreviation,
        name: user.name,
        uid: user.id,
      );
    });

    _commentAddSubject.listen(_buildAndAddComment, cancelOnError: false);
    _rateSubject.listen(_changeRating, cancelOnError: false);
    _deletionSubject.listen(_deleteComment, cancelOnError: false);

    final Stream<List<CommentDataModel>> dbStream =
        _gateway.comments(_commentsLocation);
    final Stream<List<Comment>> commentStream = _toComments(dbStream);
    final Stream<List<CommentView>> commentViewStream = _toViews(commentStream);

    _subscription =
        commentViewStream.listen(_commentsSubject.add, cancelOnError: false);
  }

  Function(String) get addComment => _commentAddSubject.sink.add;
  Stream<List<CommentView>> get comments => _commentsSubject;
  Function(String) get deleteComment => _deletionSubject.sink.add;
  Function(RateCommentEvent) get rateComment => _rateSubject.sink.add;

  void _buildAndAddComment(String userComment) {
    final comment = Comment(
      content: userComment,
      author: _currentAuthorInformation,
    );

    _gateway.add(CommentDataModel.fromComment(comment), _commentsLocation);

    _analytics.logCommentAdded(getCommentLocation(comment.id!));
  }

  Future<void> _changeRating(RateCommentEvent event) async {
    final oldViewStatus = _searchOldStatus(event.commentId);
    final userAction = event.status;

    CommentStatus newStatus = _getNewStatus(userAction, oldViewStatus);

    final uid = _currentAuthorInformation.uid;
    final commentLocation = CommentLocation.fromCommentsLocation(
        commentsLocation: _commentsLocation, commentId: event.commentId);
    final oldStatus = oldViewStatus;

    await _gateway.changeRating(uid, commentLocation, oldStatus, newStatus);
  }

  // Damit es von außen für Reportsystem zugreifbar ist.
  CommentLocation getCommentLocation(String commentId) {
    return CommentLocation.fromCommentsLocation(
        commentsLocation: _commentsLocation, commentId: commentId);
  }

  Future<void> _deleteComment(String commentId) async {
    final loc = CommentLocation.fromCommentsLocation(
        commentId: commentId, commentsLocation: _commentsLocation);
    _gateway.delete(loc);
    _analytics.logCommentDeleted(loc);
  }

  CommentStatus _getNewStatus(
      CommentEvent userAction, CommentStatus oldStatus) {
    late CommentStatus newStatus;
    if (userAction == CommentEvent.liked) {
      if (oldStatus == CommentStatus.liked) {
        newStatus = CommentStatus.notRated;
      } else if (oldStatus == CommentStatus.disliked) {
        newStatus = CommentStatus.liked;
      } else {
        newStatus = CommentStatus.liked;
      }
    } else if (userAction == CommentEvent.disliked) {
      if (oldStatus == CommentStatus.liked) {
        newStatus = CommentStatus.disliked;
      } else if (oldStatus == CommentStatus.disliked) {
        newStatus = CommentStatus.notRated;
      } else {
        newStatus = CommentStatus.disliked;
      }
    }
    return newStatus;
  }

  CommentStatus _searchOldStatus(String commentId) {
    return _commentsSubject.valueOrNull!
        .firstWhere((comment) => comment.id == commentId)
        .status;
  }

  Stream<List<Comment>> _toComments(Stream<List<CommentDataModel>> dbStream) =>
      dbStream.map((dbComments) => dbComments.map((c) => c.toModel()).toList()
        ..sort((a, b) =>
            b.age.writtenOnDateTime.compareTo(a.age.writtenOnDateTime)));

  Stream<List<CommentView>> _toViews(Stream<List<Comment>> commentStream) =>
      commentStream.map((comments) => comments
          .map((c) => _commentViewFactory.fromModel(c, courseID))
          .toList());

  @override
  void dispose() {
    _subscription?.cancel();
    _commentAddSubject.close();
    _rateSubject.close();
    _deletionSubject.close();
    _commentsSubject.close();
  }
}

class RateCommentEvent {
  final CommentEvent status;
  final String commentId;

  RateCommentEvent({required this.status, required this.commentId});
}
