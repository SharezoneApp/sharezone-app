// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_icons.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FeedbackDetailsPage extends StatelessWidget {
  const FeedbackDetailsPage({
    super.key,
    required this.feedback,
  });

  final FeedbackView feedback;

  static const tag = 'feedback-details-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Feedback')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: Column(
              children: [
                if (feedback.hasCreatedOn)
                  _CreatedOn(createdOn: feedback.createdOn!),
                if (feedback.hasRating) _Rating(rating: feedback.rating!),
                if (feedback.hasLikes) _Likes(likes: feedback.likes!),
                if (feedback.hasDislikes)
                  _Dislikes(dislikes: feedback.dislikes!),
                if (feedback.hasMissing) _Missing(missing: feedback.missing!),
                if (feedback.hasHeardFrom)
                  _HeardFrom(heardFrom: feedback.heardFrom!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreatedOn extends StatelessWidget {
  const _CreatedOn({
    super.key,
    required this.createdOn,
  });

  final String createdOn;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.today),
      title: Text(createdOn),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    return ListTile(
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
    return ListTile(
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
    return ListTile(
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
    return ListTile(
      leading: const FeedbackHeardFromIcon(),
      title: Text(heardFrom),
    );
  }
}
