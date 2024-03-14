// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

abstract class FeedbackApi {
  Future<void> sendFeedback(UserFeedback feedback);
  Stream<List<UserFeedback>> streamFeedbacks(String userId);
  Stream<List<FeedbackChatMessage>> streamChatMessages(FeedbackId feedbackId);
  Stream<UserFeedback> streamFeedback(FeedbackId feedbackId);
  void markMessageAsRead(FeedbackId feedbackId, UserId userId);
  void sendResponse({
    required FeedbackId feedbackId,
    required UserId userId,
    required String message,
  });
}
