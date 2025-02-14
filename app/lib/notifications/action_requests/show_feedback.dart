// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:feedback_shared_implementation/feedback_shared_implementation.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone/util/navigation_service.dart';

ActionRegistration<ShowFeedbackRequest> showFeedbackRegistrationWith(
  ActionRequestExecutorFunc<ShowFeedbackRequest> executorFunc,
) => ActionRegistration<ShowFeedbackRequest>(
  registerForActionTypeStrings: ShowFeedbackRequest.actionTypes,
  parseActionRequestFromNotification: _toShowFeedbackActionRequest,
  executeActionRequest: executorFunc,
);

ShowFeedbackRequest _toShowFeedbackActionRequest(
  PushNotification notification,
  PushNotificationParserInstrumentation instrumentation,
) => ShowFeedbackRequest(FeedbackId(notification.actionData['id'] as String));

/// Show the detailed view of a single feedback with the given [feedbackId].
///
/// See also [ShowFeedbackExecutor].
class ShowFeedbackRequest extends ActionRequest {
  static const Set<String> actionTypes = {'show-feedback-with-id'};

  final FeedbackId feedbackId;

  @override
  List<Object> get props => [feedbackId];

  ShowFeedbackRequest(this.feedbackId);
}

class ShowFeedbackExecutor extends ActionRequestExecutor<ShowFeedbackRequest> {
  final NavigationService? _navigationService;

  ShowFeedbackExecutor(this._navigationService);

  @override
  FutureOr<void> execute(ShowFeedbackRequest actionRequest) {
    return _navigationService!.pushWidget(
      FeedbackDetailsPage(
        feedbackId: actionRequest.feedbackId,
        onContactSupportPressed:
            () => _navigationService.pushNamed(SupportPage.tag),
      ),
      name: FeedbackDetailsPage.tag,
    );
  }
}
