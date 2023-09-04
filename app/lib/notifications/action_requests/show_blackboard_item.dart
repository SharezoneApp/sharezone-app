// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/blackboard/details/blackboard_details.dart';
import 'package:sharezone/util/navigation_service.dart';

ActionRegistration<
    ShowBlackboardItemRequest> showBlackboardItemRegistrationWith(
        ActionRequestExecutorFunc<ShowBlackboardItemRequest> executorFunc) =>
    ActionRegistration<ShowBlackboardItemRequest>(
      registerForActionTypeStrings: ShowBlackboardItemRequest.actionTypes,
      parseActionRequestFromNotification: _toShowBlackboardItemActionRequest,
      executeActionRequest: executorFunc,
    );

ShowBlackboardItemRequest _toShowBlackboardItemActionRequest(
        PushNotification notification,
        PushNotificationParserInstrumentation instrumentation) =>
    ShowBlackboardItemRequest(
        BlackboardItemId(notification.actionData['id'] as String));

/// Show the detailed view of a single blackboard item with the given
/// [blackboardItemId].
///
/// See also [ShowBlackboardItemExecutor].
class ShowBlackboardItemRequest extends ActionRequest {
  static const Set<String> actionTypes = {'show-blackboard-item-with-id'};

  final BlackboardItemId blackboardItemId;

  @override
  List<Object> get props => [blackboardItemId];

  ShowBlackboardItemRequest(this.blackboardItemId);
}

class ShowBlackboardItemExecutor
    extends ActionRequestExecutor<ShowBlackboardItemRequest> {
  final NavigationService? _navigationService;

  ShowBlackboardItemExecutor(this._navigationService);

  @override
  FutureOr<void> execute(ShowBlackboardItemRequest actionRequest) {
    return _navigationService!.pushWidget(
        BlackboardDetails.loadId('${actionRequest.blackboardItemId}'),
        name: BlackboardDetails.tag);
  }
}
