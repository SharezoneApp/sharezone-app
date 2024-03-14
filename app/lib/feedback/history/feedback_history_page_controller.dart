// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/feedback/history/feedback_history_page_analytics.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

class FeedbackHistoryPageController extends ChangeNotifier {
  final FeedbackApi api;
  final UserId userId;
  final CrashAnalytics crashAnalytics;
  final FeedbackHistoryPageAnalytics analytics;

  FeedbackHistoryPageState _state = FeedbackHistoryPageLoading();
  FeedbackHistoryPageState get state => _state;

  StreamSubscription<List<UserFeedback>>? _feedbackSubscription;

  FeedbackHistoryPageController({
    required this.api,
    required this.userId,
    required this.crashAnalytics,
    required this.analytics,
  });

  Future<void> startStreaming() async {
    _feedbackSubscription = api.streamFeedbacks('$userId').listen((feedbacks) {
      if (feedbacks.isEmpty) {
        _state = FeedbackHistoryPageEmpty();
      } else {
        _state = FeedbackHistoryPageLoaded(feedbacks.toFeedbackViews(userId));
      }
      notifyListeners();
    }, onError: (e, s) async {
      await crashAnalytics.recordError(e, s);
      _state = FeedbackHistoryPageError('$e');
      notifyListeners();
    });
  }

  void logOpenedPage() {
    analytics.logOpenedPage();
  }

  @override
  void dispose() {
    _feedbackSubscription?.cancel();
    super.dispose();
  }
}

sealed class FeedbackHistoryPageState {
  const FeedbackHistoryPageState();
}

class FeedbackHistoryPageError extends FeedbackHistoryPageState {
  final String message;

  FeedbackHistoryPageError(this.message);
}

class FeedbackHistoryPageLoading extends FeedbackHistoryPageState {}

class FeedbackHistoryPageEmpty extends FeedbackHistoryPageState {}

class FeedbackHistoryPageLoaded extends FeedbackHistoryPageState {
  final List<FeedbackView> feedbacks;

  FeedbackHistoryPageLoaded(this.feedbacks);
}
