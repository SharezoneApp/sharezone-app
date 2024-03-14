// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/src/ids/user_id.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/models/feedback_chat_message.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

class MockFeedbackApi extends FeedbackApi {
  bool get wasInvoked => invocations.isNotEmpty;

  List<UserFeedback> invocations = [];

  bool wasOnlyInvokedWith(UserFeedback? feedback) {
    return invocations.single == feedback;
  }

  @override
  Future<void> sendFeedback(UserFeedback feedback) async {
    invocations.add(feedback);
  }

  @override
  Stream<List<UserFeedback>> streamFeedbacks(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<UserFeedback> getFeedback(FeedbackId feedbackId) {
    throw UnimplementedError();
  }

  @override
  void sendResponse({
    required FeedbackId feedbackId,
    required UserId userId,
    required String message,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<FeedbackChatMessage>> streamChatMessages(FeedbackId feedbackId) {
    throw UnimplementedError();
  }
}
