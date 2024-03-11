// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/feedback/history/feedback_view.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';

class FeedbackDetailsPageController extends ChangeNotifier {
  final FeedbackApi feedbackApi;

  FeedbackDetailsPageController({required this.feedbackApi});

  FeedbackDetailsPageState state = FeedbackDetailsPageLoading();

  void loadFeedback(String feedbackId) {
    state = FeedbackDetailsPageLoading();
    notifyListeners();
    feedbackApi.getFeedback(feedbackId).then((feedback) {
      state =
          FeedbackDetailsPageLoaded(FeedbackView.fromUserFeedback(feedback));
      notifyListeners();
    }).catchError((e) {
      state = FeedbackDetailsPageError('$e', feedbackId);
      notifyListeners();
    });
  }

  void setFeedback(FeedbackView feedback) {
    state = FeedbackDetailsPageLoaded(feedback);
    notifyListeners();
  }
}

sealed class FeedbackDetailsPageState {
  const FeedbackDetailsPageState();
}

class FeedbackDetailsPageError extends FeedbackDetailsPageState {
  final String message;
  final String feedbackId;

  FeedbackDetailsPageError(this.message, this.feedbackId);
}

class FeedbackDetailsPageLoading extends FeedbackDetailsPageState {}

class FeedbackDetailsPageLoaded extends FeedbackDetailsPageState {
  final FeedbackView feedback;

  FeedbackDetailsPageLoaded(this.feedback);
}
