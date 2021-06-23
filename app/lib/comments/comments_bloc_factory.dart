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
