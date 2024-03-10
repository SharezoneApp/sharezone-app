// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/feedback/history/feedback_details_page_controller.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_icons.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FeedbackDetailsPage extends StatefulWidget {
  const FeedbackDetailsPage({
    super.key,
    this.feedbackId,
    this.feedback,
  }) : assert(feedbackId != null || feedback != null);

  final String? feedbackId;
  final FeedbackView? feedback;

  static const tag = 'feedback-details-page';

  @override
  State<FeedbackDetailsPage> createState() => _FeedbackDetailsPageState();
}

class _FeedbackDetailsPageState extends State<FeedbackDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedback = widget.feedback;
      if (feedback == null) {
        context
            .read<FeedbackDetailsPageController>()
            .loadFeedback(widget.feedbackId!);
      } else {
        context.read<FeedbackDetailsPageController>().setFeedback(feedback);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((FeedbackDetailsPageController c) => c.state);
    return Scaffold(
      appBar: AppBar(title: const Text('Mein Feedback')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: MaxWidthConstraintBox(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: switch (state) {
                FeedbackDetailsPageError() => _Error(state: state),
                FeedbackDetailsPageLoading() => const _Loading(),
                FeedbackDetailsPageLoaded(feedback: final feedback) =>
                  _Items(feedback: feedback),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const _Items(
      feedback: FeedbackView(
        feedbackId: '1',
        createdOn: '2022-01-01',
        rating: '5',
        likes: '10',
        dislikes: '2',
        missing: 'Great app!',
        heardFrom: 'Friend',
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.state,
  });

  final FeedbackDetailsPageError state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ErrorCard(
        message: Text(state.message),
        onRetryPressed: () => context
            .read<FeedbackDetailsPageController>()
            .loadFeedback(state.feedbackId),
        onContactSupportPressed: () =>
            Navigator.pushNamed(context, SupportPage.tag),
      ),
    );
  }
}

class _Items extends StatelessWidget {
  const _Items({
    required this.feedback,
  });

  final FeedbackView feedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (feedback.hasCreatedOn) _CreatedOn(createdOn: feedback.createdOn!),
        if (feedback.hasRating) _Rating(rating: feedback.rating!),
        if (feedback.hasLikes) _Likes(likes: feedback.likes!),
        if (feedback.hasDislikes) _Dislikes(dislikes: feedback.dislikes!),
        if (feedback.hasMissing) _Missing(missing: feedback.missing!),
        if (feedback.hasHeardFrom) _HeardFrom(heardFrom: feedback.heardFrom!),
      ],
    );
  }
}

class _CreatedOn extends StatelessWidget {
  const _CreatedOn({
    required this.createdOn,
  });

  final String createdOn;

  @override
  Widget build(BuildContext context) {
    return _FeedbackTile(
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
    return _FeedbackTile(
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
    return _FeedbackTile(
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
    return _FeedbackTile(
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
    return _FeedbackTile(
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
    return _FeedbackTile(
      leading: const FeedbackHeardFromIcon(),
      title: Text(heardFrom),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile({
    required this.title,
    this.leading,
  });

  final Widget? leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<FeedbackDetailsPageController, bool>(
      (c) => c.state is FeedbackDetailsPageLoading,
    );
    return GrayShimmer(
      enabled: isLoading,
      child: ListTile(
        leading: leading,
        title: isLoading
            ? Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            : title,
      ),
    );
  }
}
