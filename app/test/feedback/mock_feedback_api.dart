// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/src/ids/user_id.dart';
import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';

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

  @override
  void markMessageAsRead(FeedbackId feedbackId, UserId userId) {}

  @override
  Stream<UserFeedback> streamFeedback(FeedbackId feedbackId) {
    throw UnimplementedError();
  }

  @override
  Stream<bool> streamHasUnreadFeedbackMessages(UserId userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<UserFeedback>> getFeedbacksForSupportTeam({
    DateTime? startAfter,
    int limit = 0,
    SupportFeedbackFilter filter = SupportFeedbackFilter.all,
  }) {
    throw UnimplementedError();
  }
}
