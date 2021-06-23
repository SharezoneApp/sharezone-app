import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/comments/comment_view.dart';
import 'package:sharezone/comments/comments_bloc.dart';
import 'package:sharezone/comments/widgets/comment_widget.dart';
import 'package:sharezone/comments/widgets/user_comment_field.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone_widgets/widgets.dart';

class CommentSection extends StatelessWidget {
  final List<CommentView> comments;
  final String userAbbreviation;
  final String userName;
  final bool _loading;
  final String courseID;

  const CommentSection({
    Key key,
    this.comments = const [],
    @required this.userAbbreviation,
    @required this.userName,
    @required this.courseID,
  })  : _loading = false,
        super(key: key);

  const CommentSection.loading({
    Key key,
    @required this.userAbbreviation,
    @required this.userName,
  })  : comments = const [],
        _loading = true,
        courseID = '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CommentSectionTitle(numberOfComments: comments?.length ?? 0),
        UserCommentField(
          textFieldMessage: "Stell eine Rückfrage...",
          userAbbreviation: userAbbreviation,
        ),
        Column(children: _getChildren(context)),
      ],
    );
  }

  List<Widget> _getChildren(BuildContext context) {
    if (comments == null || _loading) {
      return [Container()];
    } else if (comments.isEmpty) {
      return [];
    } else {
      return comments.map((c) => _toCommentWidget(context, c)).toList();
    }
  }

  Widget _toCommentWidget(BuildContext context, CommentView comment) {
    final bloc = BlocProvider.of<CommentsBloc>(context);
    return Comment.fromView(
      comment,
      onRated: (commentStatus) => bloc.rateComment(
        RateCommentEvent(commentId: comment.id, status: commentStatus),
      ),
      onDelete: () => bloc.deleteComment(comment.id),
      onReport: () => openReportPage(context,
          ReportItemReference.comment(bloc.getCommentLocation(comment.id))),
    );
  }
}

class _CommentSectionTitle extends StatelessWidget {
  final int numberOfComments;

  const _CommentSectionTitle({
    Key key,
    this.numberOfComments = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DividerWithText(
      text: 'Kommentare: $numberOfComments',
      fontSize: 16,
    );
  }
}
