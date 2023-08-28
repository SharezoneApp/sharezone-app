// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/comments/comments_bloc.dart';
import 'package:sharezone/comments/comments_gateway.dart';
import 'package:user/user.dart';

import 'comment_view_factory.dart';
import 'comments_analytics.dart';

class CommentsBlocFactory extends BlocBase {
  final CommentsGateway _gateway;
  final Stream<AppUser> _userStream;
  final CommentViewFactory commentViewFactory;
  final CommentsAnalytics _analytics;

  CommentsBlocFactory(this._gateway, this._userStream, this.commentViewFactory,
      this._analytics);

  CommentsBloc fromCommentLocation(CommentsLocation location, String courseID) {
    return CommentsBloc(_gateway, location, _userStream, commentViewFactory,
        courseID, _analytics);
  }

  @override
  void dispose() {}
}
