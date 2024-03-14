// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message.dart';

class FeedbackDetailsPageController extends ChangeNotifier {
  final FeedbackApi feedbackApi;
  final UserId userId;
  final FeedbackId feedbackId;

  StreamSubscription<List<FeedbackChatMessage>>? _chatMessagesSubscription;

  FeedbackDetailsPageController({
    required this.feedbackApi,
    required this.userId,
    required this.feedbackId,
  });

  FeedbackDetailsPageState state = FeedbackDetailsPageLoading();

  void loadFeedback() {
    state = FeedbackDetailsPageLoading();
    notifyListeners();
    feedbackApi.getFeedback(feedbackId).then((feedback) {
      final currentMessages = state is FeedbackDetailsPageLoaded
          ? (state as FeedbackDetailsPageLoaded).chatMessages
          : null;
      state = FeedbackDetailsPageLoaded(
        feedback: FeedbackView.fromUserFeedback(feedback),
        chatMessages: currentMessages,
      );
      notifyListeners();
    }).catchError((e) {
      state = FeedbackDetailsPageError('$e');
      notifyListeners();
    });
  }

  void initMessagesStream() {
    _chatMessagesSubscription =
        feedbackApi.streamChatMessages(feedbackId).listen((messages) {
      final feedback = (state as FeedbackDetailsPageLoaded).feedback;
      state = FeedbackDetailsPageLoaded(
        feedback: feedback,
        chatMessages: messages,
      );
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
    feedbackApi.sendResponse(
      feedbackId: feedbackId,
      userId: userId,
      message: message,
    );
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
  final List<FeedbackChatMessage>? chatMessages;

  FeedbackDetailsPageLoaded({
    required this.feedback,
    required this.chatMessages,
  });
}
