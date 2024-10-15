// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:feedback_shared_implementation/src/api/feedback_api.dart';
import 'package:feedback_shared_implementation/src/models/feedback_id.dart';
import 'package:feedback_shared_implementation/src/pages/feedback_details_page_controller.dart';

class FeedbackDetailsPageControllerFactory {
  final FeedbackApi feedbackApi;
  final UserId userId;
  final CrashAnalytics? crashAnalytics;

  const FeedbackDetailsPageControllerFactory({
    required this.feedbackApi,
    required this.userId,
    required this.crashAnalytics,
  });

  FeedbackDetailsPageController create(FeedbackId feedbackId) {
    return FeedbackDetailsPageController(
      feedbackApi: feedbackApi,
      userId: userId,
      feedbackId: feedbackId,
      crashAnalytics: crashAnalytics,
    );
  }
}
