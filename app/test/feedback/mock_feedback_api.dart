// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

class MockFeedbackApi extends FeedbackApi {
  bool get wasInvoked => invocations.isNotEmpty;

  List<UserFeedback> invocations = [];

  bool wasOnlyInvokedWith(UserFeedback? feedback) {
    return invocations.single == feedback;
  }

  @override
  Future<void> sendFeedback(UserFeedback feedback) {
    invocations.add(feedback);
    return null;
  }
}
