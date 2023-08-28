// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/comments/comment_view.dart';
import 'package:sharezone/comments/comments_bloc.dart';
import 'package:sharezone/comments/comments_bloc_factory.dart';
import 'package:sharezone/comments/comments_gateway.dart';
import 'package:sharezone/comments/widgets/comment_section.dart';
import 'package:sharezone/util/api.dart';
import 'package:user/user.dart';

class CommentSectionBuilder extends StatefulWidget {
  const CommentSectionBuilder({
    Key? key,
    required this.itemId,
    required this.commentOnType,
    required this.courseID,
  }) : super(key: key);

  final String itemId;
  final CommentOnType commentOnType;
  final String courseID;

  @override
  _CommentSectionBuilderState createState() => _CommentSectionBuilderState();
}

class _CommentSectionBuilderState extends State<CommentSectionBuilder> {
  late CommentsBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<CommentsBlocFactory>(context).fromCommentLocation(
      CommentsLocation(
        commentOnType: widget.commentOnType,
        parentDocumentId: widget.itemId,
      ),
      widget.courseID,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return BlocProvider(
      bloc: bloc,
      child: _CommentSectionStreamBuilder(
        widget: widget,
        api: api,
        courseID: widget.courseID,
      ),
    );
  }
}

class _CommentSectionStreamBuilder extends StatelessWidget {
  const _CommentSectionStreamBuilder({
    Key? key,
    required this.widget,
    required this.api,
    required this.courseID,
  }) : super(key: key);

  final CommentSectionBuilder widget;
  final SharezoneGateway api;
  final String courseID;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CommentsBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StreamBuilder<List<CommentView>>(
        stream: bloc.comments,
        builder: (context, commentsSnap) {
          return StreamBuilder<AppUser?>(
            stream: api.user.userStream,
            builder: (context, userSnap) {
              final abbr = userSnap.data?.abbreviation ?? "?";
              final name = userSnap.data?.name ?? "";
              return commentsSnap.hasData
                  ? CommentSection(
                      comments: commentsSnap.data,
                      userAbbreviation: abbr,
                      userName: name,
                      courseID: courseID,
                    )
                  : CommentSection.loading(
                      userAbbreviation: abbr,
                      userName: name,
                    );
            },
          );
        },
      ),
    );
  }
}
