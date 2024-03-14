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
import 'package:intl/intl.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message.dart';

class FeedbackDetailsPageController extends ChangeNotifier {
  final FeedbackApi feedbackApi;
  final UserId userId;
  final FeedbackId feedbackId;
  final CrashAnalytics crashAnalytics;

  StreamSubscription<List<FeedbackChatMessage>>? _chatMessagesSubscription;

  FeedbackDetailsPageController({
    required this.feedbackApi,
    required this.userId,
    required this.feedbackId,
    required this.crashAnalytics,
  });

  FeedbackDetailsPageState state = FeedbackDetailsPageLoading();

  void loadFeedback() {
    state = FeedbackDetailsPageLoading();
    notifyListeners();
    feedbackApi.getFeedback(feedbackId).then((feedback) {
      state = FeedbackDetailsPageLoaded(
        feedback: FeedbackView.fromUserFeedback(feedback),
        chatMessages: _getCurrentMessages(),
      );
      notifyListeners();
    }).catchError((e, s) {
      state = FeedbackDetailsPageError('$e');
      crashAnalytics.recordError('Error when loading feedback: $e', s);
      notifyListeners();
    });
  }

  void initMessagesStream() {
    _chatMessagesSubscription =
        feedbackApi.streamChatMessages(feedbackId).listen((messages) {
      final messageViews = messages
          .map(
            (e) => FeedbackMessageView(
              message: e.text,
              isMyMessage: e.senderId == userId,
              sentAt: DateFormat.yMd().add_jm().format(e.sentAt),
            ),
          )
          .toList();
      state = FeedbackDetailsPageLoaded(
        feedback: _getCurrentFeedbackView(),
        chatMessages: messageViews,
      );
      notifyListeners();
    }, onError: (e, s) {
      state = FeedbackDetailsPageError('$e');
      crashAnalytics.recordError('Error when loading messages: $e', s);
      notifyListeners();
    });
  }

  void setFeedback(FeedbackView feedback) {
    state = FeedbackDetailsPageLoaded(
      feedback: feedback,
      chatMessages: null,
    );
    notifyListeners();
  }

  void sendResponse(String message) {
    try {
      feedbackApi.sendResponse(
        feedbackId: feedbackId,
        userId: userId,
        message: message,
      );
    } on Exception catch (e, s) {
      crashAnalytics.recordError('Error when sending response: $e', s);
      rethrow;
    }
  }

  FeedbackView? _getCurrentFeedbackView() {
    final currentFeedback = state is FeedbackDetailsPageLoaded
        ? (state as FeedbackDetailsPageLoaded).feedback
        : null;
    return currentFeedback;
  }

  List<FeedbackMessageView>? _getCurrentMessages() {
    final currentMessages = state is FeedbackDetailsPageLoaded
        ? (state as FeedbackDetailsPageLoaded).chatMessages
        : null;
    return currentMessages;
  }

  @override
  void dispose() {
    _chatMessagesSubscription?.cancel();
    super.dispose();
  }
}

sealed class FeedbackDetailsPageState {
  const FeedbackDetailsPageState();
}

class FeedbackDetailsPageError extends FeedbackDetailsPageState {
  final String message;

  FeedbackDetailsPageError(this.message);
}

class FeedbackDetailsPageLoading extends FeedbackDetailsPageState {}

class FeedbackDetailsPageLoaded extends FeedbackDetailsPageState {
  final FeedbackView? feedback;
  final List<FeedbackMessageView>? chatMessages;

  FeedbackDetailsPageLoaded({
    required this.feedback,
    required this.chatMessages,
  });
}
