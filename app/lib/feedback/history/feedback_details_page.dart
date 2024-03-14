// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/feedback/history/feedback_details_page_controller.dart';
import 'package:sharezone/feedback/history/feedback_details_page_controller_factory.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_icons.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FeedbackDetailsPage extends StatefulWidget {
  const FeedbackDetailsPage({
    super.key,
    required this.feedbackId,
    this.feedback,
  });

  final FeedbackId feedbackId;
  final FeedbackView? feedback;

  static const tag = 'feedback-details-page';

  @override
  State<FeedbackDetailsPage> createState() => _FeedbackDetailsPageState();
}

class _FeedbackDetailsPageState extends State<FeedbackDetailsPage> {
  late FeedbackDetailsPageController controller;

  @override
  void initState() {
    super.initState();

    controller = context
        .read<FeedbackDetailsPageControllerFactory>()
        .create(widget.feedbackId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedback = widget.feedback;
      if (feedback == null) {
        controller.loadFeedback();
      } else {
        controller.setFeedback(feedback);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        appBar: AppBar(title: const Text('Mein Feedback')),
        body: const SingleChildScrollView(
          child: SafeArea(
            child: MaxWidthConstraintBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeedbackTiles(),
                  _Messages(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const _WriteResponseField(),
      ),
    );
  }
}

class _FeedbackTiles extends StatelessWidget {
  const _FeedbackTiles();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedbackDetailsPageController>().state;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: switch (state) {
        FeedbackDetailsPageError() => _Error(state: state),
        FeedbackDetailsPageLoading() => const _Loading(),
        FeedbackDetailsPageLoaded(feedback: final feedback) =>
          _Items(feedback: feedback),
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return _Items(
      feedback: FeedbackView(
        id: FeedbackId('1'),
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
        onRetryPressed: () =>
            context.read<FeedbackDetailsPageController>().loadFeedback(),
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

  final FeedbackView? feedback;

  @override
  Widget build(BuildContext context) {
    final feedback = this.feedback;
    if (feedback == null) {
      return const SizedBox();
    }
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

class _Messages extends StatelessWidget {
  const _Messages();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rückmeldung vom Sharezone-Team:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              _ChatBubble(
                text: 'Vielen Dank für Ihr Feedback!',
                backgroundColor: Colors.grey[300]!,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 6),
              _ChatBubble(
                text: 'Wir freuen uns, dass Sie unsere App nutzen!',
                backgroundColor: Colors.grey[300]!,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 6),
              _ChatBubble(
                text: 'Selbst meine Oma kann eine bessere App programmieren!',
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WriteResponseField extends StatefulWidget {
  const _WriteResponseField();

  @override
  State<_WriteResponseField> createState() => _WriteResponseFieldState();
}

class _WriteResponseFieldState extends State<_WriteResponseField> {
  String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        MaxWidthConstraintBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Antwort schreiben...',
                    ),
                    onChanged: (value) => setState(() => message = value),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  tooltip: 'Senden',
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final isMessageValid =
                        message != null && message!.isNotEmpty;
                    if (!isMessageValid) {
                      showSnackSec(
                        context: context,
                        text: 'Bitte gebe eine Nachricht ein!',
                      );
                      return;
                    }

                    final controller =
                        context.read<FeedbackDetailsPageController>();
                    controller.sendResponse(message!);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.backgroundColor,
    required this.alignment,
  });

  final String text;
  final Color backgroundColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: MarkdownBody(data: text),
      ),
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
