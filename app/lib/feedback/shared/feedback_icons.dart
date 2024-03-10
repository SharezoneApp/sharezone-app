import 'package:flutter/material.dart';

class FeedbackRatingIcon extends StatelessWidget {
  const FeedbackRatingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.star);
  }
}

class FeedbackLikesIcon extends StatelessWidget {
  const FeedbackLikesIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.thumb_up);
  }
}

class FeedbackDislikesIcon extends StatelessWidget {
  const FeedbackDislikesIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.thumb_down);
  }
}

class FeedbackMissingIcon extends StatelessWidget {
  const FeedbackMissingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.comment);
  }
}

class FeedbackHeardFromIcon extends StatelessWidget {
  const FeedbackHeardFromIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.search);
  }
}
