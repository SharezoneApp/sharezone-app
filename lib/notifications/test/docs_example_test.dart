// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:test/test.dart';
import 'package:notifications/notifications.dart';

// Because this file is an example for the documentation, we allow to use the
// print method.
//
// ignore_for_file: avoid_print

void main() {
  test('Example usage for documentation of the $PushNotificationActionHandler',
      () {
    final printSecretMessageRegistration =
        ActionRegistration<PrintSecretMessage>(
      registerForActionTypeStrings: {'print-secret-string'},
      parseActionRequestFromNotification: (notification, instrumentation) {
        return PrintSecretMessage(
          notification.actionData['secret-message'] ?? 'no secret message',
        );
      },
      executeActionRequest: (request) {
        print(request.stringToPrint);
      },
    );

    final handler = PushNotificationActionHandler(
      actionRegistrations: [printSecretMessageRegistration],
      onFatalParsingError: (notification, e) {},
      onUnhandledActionType: (notification) {},
      instrumentation: LoggingPushNotificationActionHandlerInstrumentation(),
    );

    handler.handlePushNotification(
      const PushNotification(
        actionType: 'print-secret-string',
        actionData: {'secret-message': 'SHAREZONE4EVER'},
        title: 'Title',
        body: 'Body',
      ),
    );
  });
}

class PrintSecretMessage extends ActionRequest {
  final String stringToPrint;

  PrintSecretMessage(this.stringToPrint);

  @override
  List<Object> get props => [stringToPrint];
}

class LoggingPushNotificationActionHandlerInstrumentation
    extends PushNotificationActionHandlerInstrumentation {
  @override
  void actionExecutedSuccessfully(ActionRequest actionRequest) {}

  @override
  void actionExecutionFailed(
      ActionRequest actionRequest, exception, StackTrace stacktrace) {}

  @override
  void startHandlingPushNotification(PushNotification pushNotification) {}

  @override
  void parsingFailedFataly(
      PushNotification pushNotification, exception, StackTrace stacktrace) {}

  @override
  void parsingFailedNonFatalyOnAttribute(String attributeName,
      {fallbackValueChosenInstead,
      required PushNotification notification,
      error}) {}

  @override
  void parsingFailedOnUnknownActionType(PushNotification pushNotification) {}

  @override
  void parsingSucceeded(
      PushNotification pushNotification, ActionRequest actionRequest) {}
}
