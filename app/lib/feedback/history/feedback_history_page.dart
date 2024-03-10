// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/feedback/history/feedback_details_page.dart';
import 'package:sharezone/feedback/history/feedback_history_page_controller.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_icons.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FeedbackHistoryPage extends StatefulWidget {
  const FeedbackHistoryPage({super.key});

  static const tag = 'feedback-history';

  @override
  State<FeedbackHistoryPage> createState() => _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends State<FeedbackHistoryPage> {
  @override
  void initState() {
    super.initState();

    final controller = context.read<FeedbackHistoryPageController>();
    controller.startStreaming();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((FeedbackHistoryPageController c) => c.state);
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Feedbacks')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state) {
          FeedbackHistoryPageError(message: final message) =>
            _Error(message: message),
          FeedbackHistoryPageLoading() => const _Loading(),
          FeedbackHistoryPageLoaded(feedbacks: final feedbacks) =>
            _List(feedbacks: feedbacks),
          FeedbackHistoryPageEmpty() => const _Empty(),
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  static const dummyFeedbacks = [
    FeedbackView(
      feedbackId: '1',
      createdOn: '2022-01-01',
      rating: '5',
      likes: '10',
      dislikes: '2',
      missing: 'Great app!',
      heardFrom: 'Friend',
    ),
    FeedbackView(
      feedbackId: '2',
      createdOn: '2022-01-02',
      rating: '4',
      likes: '5',
      dislikes: '1',
      missing: 'Good app!',
      heardFrom: 'Colleague',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const _List(feedbacks: dummyFeedbacks);
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: ErrorCard(
              message: Text(message),
              onContactSupportPressed: () =>
                  Navigator.pushNamed(context, SupportPage.tag),
            ),
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.feedbacks,
  });

  final List<FeedbackView> feedbacks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final feedback = feedbacks[index];
        final isFirst = index == 0;
        final isLast = index == feedbacks.length - 1;
        return Padding(
          padding: EdgeInsets.only(
            top: isFirst ? 6 : 0,
            bottom: isLast ? 6 : 0,
          ),
          child: _FeedbackCard(feedback: feedback),
        );
      },
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.feedback,
  });

  final FeedbackView feedback;

  void pushDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackDetailsPage(feedback: feedback),
        settings: const RouteSettings(name: FeedbackDetailsPage.tag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: CustomCard(
            onTap: () => pushDetailsPage(context),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
    final isLoading = context.select<FeedbackHistoryPageController, bool>(
      (c) => c.state is FeedbackHistoryPageLoading,
    );
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

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 48),
          SizedBox(height: 12),
          Text('Du hast bisher kein Feedback gegeben 😢'),
        ],
      ),
    );
  }
}
