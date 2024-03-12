// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:notifications/notifications.dart';
import 'package:sharezone/feedback/history/feedback_details_page.dart';
import 'package:sharezone/util/navigation_service.dart';

ActionRegistration<ShowFeedbackRequest> showFeedbackRegistrationWith(
        ActionRequestExecutorFunc<ShowFeedbackRequest> executorFunc) =>
    ActionRegistration<ShowFeedbackRequest>(
      registerForActionTypeStrings: ShowFeedbackRequest.actionTypes,
      parseActionRequestFromNotification: _toShowFeedbackActionRequest,
      executeActionRequest: executorFunc,
    );

ShowFeedbackRequest _toShowFeedbackActionRequest(PushNotification notification,
        PushNotificationParserInstrumentation instrumentation) =>
    ShowFeedbackRequest(notification.actionData['id'] as String);

/// Show the detailed view of a single feedback with the given [feedbackId].
///
/// See also [ShowFeedbackExecutor].
class ShowFeedbackRequest extends ActionRequest {
  static const Set<String> actionTypes = {'show-feedback-with-id'};

  final String feedbackId;

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
      FeedbackDetailsPage(feedbackId: actionRequest.feedbackId),
      name: FeedbackDetailsPage.tag,
    );
  }
}
