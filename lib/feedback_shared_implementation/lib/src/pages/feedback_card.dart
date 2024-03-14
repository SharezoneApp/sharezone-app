// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

typedef IsLoading = bool;

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.view,
    required this.onContactSupportPressed,
    required this.isLoading,
  });

  final FeedbackView view;
  final VoidCallback? onContactSupportPressed;
  final bool isLoading;

  void pushDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackDetailsPage(
          feedbackId: view.id,
          onContactSupportPressed: onContactSupportPressed,
        ),
        settings: const RouteSettings(name: FeedbackDetailsPage.tag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<IsLoading>.value(
      value: isLoading,
      child: MaxWidthConstraintBox(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: CustomCard(
              onTap: () => pushDetailsPage(context),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (view.hasCreatedOn) _CreatedOn(createdOn: view.createdOn!),
                  if (view.hasRating) _Rating(rating: view.rating!),
                  if (view.hasLikes) _Likes(likes: view.likes!),
                  if (view.hasDislikes) _Dislikes(dislikes: view.dislikes!),
                  if (view.hasMissing) _Missing(missing: view.missing!),
                  if (view.hasHeardFrom) _HeardFrom(heardFrom: view.heardFrom!),
                  _LastMessage(view),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LastMessage extends StatelessWidget {
  const _LastMessage(this.view);

  final FeedbackView view;

  @override
  Widget build(BuildContext context) {
    final hasMessage = view.hasLastMessage;
    if (!hasMessage) return const SizedBox();

    final hasUnreadMessages = view.hasUnreadMessages ?? false;
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.question_answer),
              if (hasUnreadMessages)
                Positioned(
                  top: -5,
                  left: -5,
                  child: Icon(
                    Icons.brightness_1,
                    size: 15,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
          mouseCursor: SystemMouseCursors.click,
          title: Text(
            'Letzte Nachricht ${hasUnreadMessages ? '(ungelesen)' : ''}',
            style: TextStyle(
                fontWeight: hasUnreadMessages ? FontWeight.w500 : null),
          ),
          subtitle: Text(
            'Sharezone Team: Vielen Dank für dein Feedback!',
            style: TextStyle(
                fontWeight: hasUnreadMessages ? FontWeight.w500 : null),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CreatedOn extends StatelessWidget {
  const _CreatedOn({required this.createdOn});

  final String createdOn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Text(
        createdOn,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCardTile(
      leading: const FeedbackRatingIcon(),
      title: Text(rating),
    );
  }
}

class _Likes extends StatelessWidget {
  const _Likes({required this.likes});

  final String likes;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCardTile(
      leading: const FeedbackLikesIcon(),
      title: Text(likes),
    );
  }
}

class _Dislikes extends StatelessWidget {
  const _Dislikes({required this.dislikes});

  final String dislikes;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCardTile(
      leading: const FeedbackDislikesIcon(),
      title: Text(dislikes),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing({required this.missing});

  final String missing;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCardTile(
      leading: const FeedbackMissingIcon(),
      title: Text(missing),
    );
  }
}

class _HeardFrom extends StatelessWidget {
  const _HeardFrom({required this.heardFrom});

  final String heardFrom;

  @override
  Widget build(BuildContext context) {
    return _FeedbackCardTile(
      leading: const FeedbackHeardFromIcon(),
      title: Text(heardFrom),
    );
  }
}

class _FeedbackCardTile extends StatelessWidget {
  const _FeedbackCardTile({
    required this.title,
    this.leading,
  });

  final Widget? leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.read<IsLoading>();
    return GrayShimmer(
      enabled: isLoading,
      child: ListTile(
        leading: leading,
        mouseCursor: SystemMouseCursors.click,
        title: isLoading
            ? Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            : DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: title,
              ),
      ),
    );
  }
}
