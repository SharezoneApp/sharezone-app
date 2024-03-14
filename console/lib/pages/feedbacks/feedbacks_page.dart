// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

/// The user ID of the support team.
///
/// We use a shared user ID so that multiple Sharezone members can work on the
/// feedbacks. For example the status of unread messages is grouped by user ID.
/// This way, all members of the support team see the same unread messages.
final supportTeamUserId = UserId('support-team');

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({super.key});

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  var _items = <FeedbackView>[];
  DateTime? _lastCreatedAt;
  var _isLoading = false;
  var _hasReachedMax = false;
  final queryLimit = 10;
  final FeedbackApi _api = FirebaseFeedbackApi(FirebaseFirestore.instance);

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    log('Fetching data...');

    // Load 10 more feedbacks from Firestore

    final newFeedbacks = await _api.getFeedbacksForSupportTeam(
      startAfter: _lastCreatedAt,
      limit: queryLimit,
    );

    if (!mounted) {
      return;
    }

    if (newFeedbacks.isNotEmpty) {
      _lastCreatedAt = newFeedbacks.last.createdOn;
    }

    final isFinished = newFeedbacks.length < queryLimit;
    if (isFinished) {
      setState(() {
        _isLoading = false;
        _hasReachedMax = true;
      });
      return;
    }

    setState(() {
      _isLoading = false;
      _items = [
        ..._items,
        ...newFeedbacks
            .map((f) => FeedbackView.fromUserFeedback(f, supportTeamUserId)),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedbacks'),
      ),
      body: InfiniteList(
        itemCount: _items.length,
        isLoading: _isLoading,
        onFetchData: _fetchData,
        hasReachedMax: _hasReachedMax,
        loadingBuilder: (context) => _Loading(),
        errorBuilder: (context) => _Error(),
        itemBuilder: (context, index) {
          final feedback = _items[index];
          return FeedbackCard(
            view: feedback,
            isLoading: false,
            pushDetailsPage: (feedbackId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackDetailsPage(
                    feedbackId: feedbackId,
                    onContactSupportPressed: null,
                  ),
                  settings: const RouteSettings(name: FeedbackDetailsPage.tag),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text('Error loading feedbacks :('),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return FeedbackCard(
      view: FeedbackView(
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
      pushDetailsPage: null,
      isLoading: true,
    );
  }
}
