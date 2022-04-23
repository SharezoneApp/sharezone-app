// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/comments/comment_view.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';

import '../misc.dart';

typedef RatingCallback = void Function(CommentEvent newStatus);

class Comment extends StatelessWidget {
  final String avatarText;
  final String userComment;
  final String userName;
  final String commentAge;
  final String likes;
  final bool hasPermissionsToMangeComments;
  final CommentStatus status;
  final RatingCallback onRated;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const Comment({
    Key key,
    this.avatarText = "?",
    this.userComment = "",
    this.userName = "Max Mustermann",
    this.commentAge = "?",
    this.likes = "0",
    this.status = CommentStatus.notRated,
    this.hasPermissionsToMangeComments = false,
    this.onRated,
    this.onReport,
    this.onDelete,
  }) : super(key: key);

  Comment.fromView(
    CommentView comment, {
    @required this.onRated,
    @required this.onDelete,
    @required this.onReport,
  })  : avatarText = comment.avatarAbbreviation,
        userComment = comment.content,
        userName = comment.userName,
        commentAge = comment.commentAge,
        likes = comment.likes,
        hasPermissionsToMangeComments = comment.hasPermissionsToManageComments,
        status = comment.status;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Padding(
        key: Key("$userComment$userName"),
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 8),
            _Avatar(avatarText: avatarText),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$userName • $commentAge",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  MarkdownBody(
                    data: userComment,
                    selectable: true,
                    softLineBreak: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(a: linkStyle(context, 14)),
                    onTapLink: (url, _, __) => launchURL(url, context: context),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => onRated(CommentEvent.liked),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Icon(
                          Icons.thumb_up,
                          size: 17.5,
                          color: status == CommentStatus.liked
                              ? Colors.green
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(likes,
                          style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onRated(CommentEvent.disliked),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Icon(
                          Icons.thumb_down,
                          size: 17.5,
                          color: status == CommentStatus.disliked
                              ? Colors.red
                              : Colors.grey[500],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () => openCommentSheet(context),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Icon(Icons.more_vert,
                                  color: Colors.grey[500]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Future<void> openCommentSheet(BuildContext context) async {
    final action = await showModalBottomSheet<_CommentSheetAction>(
      context: context,
      builder: (context) => _CommentSheet(
        avatarAbbreviation: avatarText,
        authorName: userName,
        content: userComment,
        hasPermissionsToMangeComments: hasPermissionsToMangeComments,
      ),
    );

    switch (action) {
      case _CommentSheetAction.copy:
        copyToClipboardAndShowConfirmation(context);
        break;
      case _CommentSheetAction.delete:
        deleteComment(context);
        break;
      case _CommentSheetAction.report:
        onReport();
        break;
      default:
    }
  }

  Future<void> deleteComment(BuildContext context) async {
    final result = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      right: AdaptiveDialogAction.delete,
      defaultValue: false,
      content:
          const Text("Möchtest du wirklich den Kommentar für alle löschen?"),
    );

    if (result) {
      onDelete();
      showSnack(
        duration: const Duration(milliseconds: 1600),
        text: 'Kommentar wurde gelöscht.',
        context: context,
      );
    }
  }

  void copyToClipboardAndShowConfirmation(BuildContext context) {
    Clipboard.setData(ClipboardData(text: userComment));
    showSnack(
      duration: const Duration(milliseconds: 1600),
      text: 'Text wurde in die Zwischenablage kopiert',
      context: context,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key key, @required this.avatarText}) : super(key: key);

  final String avatarText;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(
        avatarText,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      radius: 18,
    );
  }
}

enum _CommentSheetAction { copy, report, delete }

class _CommentSheet extends StatelessWidget {
  const _CommentSheet({
    Key key,
    this.avatarAbbreviation,
    this.authorName,
    this.content,
    this.hasPermissionsToMangeComments,
  }) : super(key: key);

  final String avatarAbbreviation;
  final String authorName;
  final String content;
  final bool hasPermissionsToMangeComments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                _Avatar(avatarText: avatarAbbreviation),
                const SizedBox(width: 24),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(authorName, style: TextStyle(fontSize: 16)),
                      Text(
                        content,
                        style: TextStyle(color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Text kopieren"),
            leading: const Icon(Icons.content_copy),
            onTap: () => Navigator.pop(context, _CommentSheetAction.copy),
          ),
          ListTile(
            title: const Text("Kommentar melden"),
            leading: reportIcon,
            onTap: () => Navigator.pop(context, _CommentSheetAction.report),
          ),
          if (hasPermissionsToMangeComments)
            ListTile(
              title: const Text("Löschen"),
              leading: const Icon(Icons.delete),
              onTap: () => Navigator.pop(context, _CommentSheetAction.delete),
            )
        ],
      ),
    );
  }
}
