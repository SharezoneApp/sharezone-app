// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2


import 'package:sharezone/feedback/src/cache/feedback_cache.dart';

class MockFeedbackCache implements FeedbackCache {
  bool hasCooldown = true;

  @override
  Future<bool> hasFeedbackSubmissionCooldown(Duration feedbackCooldown) async {
    return hasCooldown;
  }

  @override
  Future<void> setLastSubmit() {
    return null;
  }

}