// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:feedback_shared_implementation/src/models/feedback_chat_message.dart';
import 'package:feedback_shared_implementation/src/models/feedback_id.dart';
import 'package:feedback_shared_implementation/src/models/user_feedback.dart';

/// Filters that can be applied when querying feedbacks for the support team.
enum SupportFeedbackFilter { all, unreadMessages, noMessages }

abstract class FeedbackApi {
  Future<void> sendFeedback(UserFeedback feedback);
  Stream<List<UserFeedback>> streamFeedbacks(String userId);
  Stream<List<FeedbackChatMessage>> streamChatMessages(FeedbackId feedbackId);
  Stream<UserFeedback> streamFeedback(FeedbackId feedbackId);
  Stream<bool> streamHasUnreadFeedbackMessages(UserId userId);
  Future<List<UserFeedback>> getFeedbacksForSupportTeam({
    DateTime? startAfter,
    int limit = 0,
    SupportFeedbackFilter filter = SupportFeedbackFilter.all,
  });
  void markMessageAsRead(FeedbackId feedbackId, UserId userId);
  void sendResponse({
    required FeedbackId feedbackId,
    required UserId userId,
    required String message,
  });
}
