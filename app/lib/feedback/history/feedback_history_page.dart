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
import 'package:sharezone/feedback/history/feedback_history_page_controller.dart';
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
          FeedbackHistoryPageLoaded(feedbacks: final feedbacks) => _List(
              feedbacks: feedbacks,
              isLoading: false,
            ),
          FeedbackHistoryPageEmpty() => const _Empty(),
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  static final dummyFeedbacks = [
    const FeedbackView(
      id: FeedbackId('1'),
      createdOn: '2022-01-01',
      rating: '5',
      likes: '10',
      dislikes: '2',
      missing: 'Great app!',
      heardFrom: 'Friend',
      hasUnreadMessages: false,
      lastMessage: null,
    ),
    const FeedbackView(
      id: FeedbackId('2'),
      createdOn: '2022-01-02',
      rating: '4',
      likes: '5',
      dislikes: '1',
      missing: 'Good app!',
      heardFrom: 'Colleague',
      hasUnreadMessages: false,
      lastMessage: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _List(
      feedbacks: dummyFeedbacks,
      isLoading: true,
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.feedbacks,
    required this.isLoading,
  });

  final List<FeedbackView> feedbacks;
  final bool isLoading;

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
          child: FeedbackCard(
            pushDetailsPage: (feedbackId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackDetailsPage(
                    feedbackId: feedbackId,
                    onContactSupportPressed: () =>
                        Navigator.pushNamed(context, SupportPage.tag),
                  ),
                  settings: const RouteSettings(name: FeedbackDetailsPage.tag),
                ),
              );
            },
            view: feedback,
            isLoading: isLoading,
          ),
        );
      },
    );
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
