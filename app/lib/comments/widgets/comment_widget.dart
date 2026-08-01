// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/comments/comment_view.dart';
import 'package:sharezone/report/report_icon.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

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
    super.key,
    this.avatarText = "?",
    this.userComment = "",
    this.userName = "Max Mustermann",
    this.commentAge = "?",
    this.likes = "0",
    this.status = CommentStatus.notRated,
    this.hasPermissionsToMangeComments = false,
    required this.onRated,
    required this.onReport,
    required this.onDelete,
  });

  Comment.fromView(
    CommentView comment, {
    super.key,
    required this.onRated,
    required this.onDelete,
    required this.onReport,
  }) : avatarText = comment.avatarAbbreviation,
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
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context),
                    ).copyWith(a: linkStyle(context, 14)),
                    onTapLink:
                        (url, href, _) => launchMarkdownLinkWithWarning(
                          href: href ?? url,
                          text: url,
                          keyValueStore: context.read<KeyValueStore>(),
                          context: context,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () => onRated(CommentEvent.liked),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Icon(
                          Icons.thumb_up,
                          size: 17.5,
                          color:
                              status == CommentStatus.liked
                                  ? Colors.green
                                  : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        likes,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onRated(CommentEvent.disliked),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Icon(
                          Icons.thumb_down,
                          size: 17.5,
                          color:
                              status == CommentStatus.disliked
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
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.grey[500],
                              ),
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
      builder:
          (context) => _CommentSheet(
            avatarAbbreviation: avatarText,
            authorName: userName,
            content: userComment,
            hasPermissionsToMangeComments: hasPermissionsToMangeComments,
          ),
    );

    if (!context.mounted) return;

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
      right: AdaptiveDialogAction.delete(context),
      defaultValue: false,
      content: Text(context.l10n.commentDeletePrompt),
    );

    if (result == true && context.mounted) {
      onDelete();
      showSnack(
        duration: const Duration(milliseconds: 1600),
        text: context.l10n.commentDeletedConfirmation,
        context: context,
      );
    }
  }

  void copyToClipboardAndShowConfirmation(BuildContext context) {
    Clipboard.setData(ClipboardData(text: userComment));
    showSnack(
      duration: const Duration(milliseconds: 1600),
      text: context.l10n.commonTextCopiedToClipboard,
      context: context,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarText});

  final String avatarText;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      radius: 18,
      child: Text(avatarText, style: const TextStyle(color: Colors.white)),
    );
  }
}

enum _CommentSheetAction { copy, report, delete }

class _CommentSheet extends StatelessWidget {
  const _CommentSheet({
    required this.avatarAbbreviation,
    required this.authorName,
    required this.content,
    required this.hasPermissionsToMangeComments,
  });

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
                      Text(authorName, style: const TextStyle(fontSize: 16)),
                      Text(
                        content,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(context.l10n.commentActionsCopyText),
            leading: const Icon(Icons.content_copy),
            onTap: () => Navigator.pop(context, _CommentSheetAction.copy),
          ),
          ListTile(
            title: Text(context.l10n.commentActionsReport),
            leading: reportIcon,
            onTap: () => Navigator.pop(context, _CommentSheetAction.report),
          ),
          if (hasPermissionsToMangeComments)
            ListTile(
              title: Text(context.l10n.commonActionsDelete),
              leading: const Icon(Icons.delete),
              onTap: () => Navigator.pop(context, _CommentSheetAction.delete),
            ),
        ],
      ),
    );
  }
}
