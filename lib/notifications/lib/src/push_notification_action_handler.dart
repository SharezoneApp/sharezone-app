// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:notifications/notifications.dart';
import 'package:notifications/src/notification_parser.dart';

import 'action_executor.dart';

export 'action_request.dart';
export 'instrumentation.dart' hide PushNotificationParserInstrumentationFactory;
export 'push_notification.dart';

/// A class that to parse and execute actions of [PushNotification] by a user
/// provided configuration.
///
/// E.g.: If a "Max added homework 'page 23 3b)' to 'math 8b' course"
/// notification comes in this class will be invoked if the user taps on the
/// notification. In this example invoking [handlePushNotification] might result
/// in opening the details page of the mentioned homework.
///
/// [PushNotificationActionHandler] doesn't implement the exact actions and parsing
/// logic itself but rather gives an instrumented, structured and opinionated
/// way for a client of this class to provide their own parsing and handling of
/// [PushNotification].
///
/// Opionated in this context means that this class enacts a specific way on how
/// a [PushNotification] is structured and how a [ActionRegistration] will be
/// selected.
///
/// In practice a [PushNotification] needs to have an
/// [PushNotification.actionType] (e.g. `'show-homework'`) which may have
/// additional data [PushNotification.actionData] (e.g. \
/// `{'id': 'homework-123'`).
///
/// With the [PushNotification.actionType] a user-provided [ActionRegistration]
/// can be selected where [ActionRegistration.registerForActionTypeStrings]
/// equals the [PushNotification.actionType].
///
/// Then selected [ActionRegistration] will then be used to parse an
/// [ActionRequest] from the [PushNotification] (e.g. \
/// `ShowHomework(id: 'homework-123')`) via
/// [ActionRegistration.parseActionRequestFromNotification].
///
/// The parsed [ActionRequest] will then be passed on
/// [ActionRegistration.executeActionRequest] to execute the action of the
/// parsed [ActionRequest] (e.g. open a page showing the homework with the id
/// 'homework-123').
///
/// The lifecycle of handling the [PushNotification] is instrumented with a
/// user-provided implementation of the [PushNotificationActionHandlerInstrumentation]
/// (could be used for logging, analytics or performance monitoring).
///
/// ```dart
/// class PrintSecretMessage extends ActionRequest {
///  final String stringToPrint;
///
///  PrintSecretMessage(this.stringToPrint);
///
///  @override
///  List<Object> get props => [stringToPrint];
/// }
///
/// void main() {
///  final printSecretMessageRegistration = ActionRegistration<PrintSecretMessage>(
///    /// The [PushNotification.actionType] that will be handled by this [ActionRegistration].
///    registerForActionTypeStrings: {'print-secret-string'},
///
///    /// The method to parse the [PrintSecretMessage] [ActionRequest] from the
///    /// [PushNotification].
///    parseActionRequestFromNotification: (notification, _) {
///      return PrintSecretMessage(
///        notification.actionData['secret-message'] ?? 'no secret message',
///      );
///    },
///
///    /// The method that executes the action that the [ActionRequest] represents.
///    executeActionRequest: (request) {
///      print(request.stringToPrint);
///    },
///  );
///
///  // Set up the handler (we omitted `onFatalParsingError` and
///  // `onUnhandledActionType` for simplicity).
///  final handler = PushNotificationActionHandler(
///    actionRegistrations: [printSecretMessageRegistration],
///    onFatalParsingError: (notification, e) {},
///    onUnhandledActionType: (notification) {},
///    instrumentation: LoggingPushNotificationActionHandlerInstrumentation(),
///  );
///
///  // Will print 'SHAREZONE4EVER' into the console.
///  handler.handlePushNotification(
///    PushNotification(
///      actionType: 'print-secret-string',
///      actionData: {'secret-message': 'SHAREZONE4EVER'},
///      title: 'Title',
///      body: 'Body',
///    ),
///  );
/// }
/// ```
class PushNotificationActionHandler {
  final PushNotificationParser parser;
  final ActionExecutor executer;
  final PushNotificationActionHandlerInstrumentation instrumentation;

  /// Called if there could be no [ActionRegistration] found where
  /// [PushNotification.actionType] equals the [PushNotification.actionType] of
  /// a [PushNotification] that was passed to [handlePushNotification].
  ///
  /// This might happen if an old client receives a [PushNotification] with a
  /// new [PushNotification.actionType] that has been introduced in only a more
  /// recent version of the client.
  ///
  /// Might be used to notify the user of an error. Should NOT be used to log
  /// the error (at least not in the same form as in [instrumentation]) as this
  /// will already be logged inside [handlePushNotification] by
  /// [instrumentation.parsingFailedOnUnknownActionType].
  ///
  /// This function should not throw. If it does [handlePushNotification] will
  /// let the error go further up the call-chain.
  final FutureOr<void> Function(PushNotification) onUnhandledActionType;

  /// Called if the [pushNotification] couldn't be parsed into an
  /// [ActionRequest]. This means that
  /// [ActionRegistration.parseActionRequestFromNotification] threw an error as
  /// it couldn't recover from a invalid [PushNotification].
  ///
  /// Might be used to notify the user of an error. Should NOT be used to log
  /// the error as [handlePushNotification] logs it via
  /// [instrumentation.parsingFailedFataly].
  ///
  /// This function should not throw. If it does [handlePushNotification] will
  /// let the error go further up the call-chain.
  final FutureOr<void> Function(PushNotification notification, dynamic error)
      onFatalParsingError;

  /// Creates a new [PushNotificationActionHandler] that uses the
  /// [actionRegistrations] to handle incomming [PushNotification] inside
  /// [handlePushNotification].
  ///
  /// Several [actionRegistrations] are not allowed to register for the same
  /// [ActionRegistration.registerForActionTypeStrings]. An
  /// [DuplicateRegistrationsError] will be thrown in this case. This is check
  /// only run in debug mode.
  PushNotificationActionHandler({
    required List<ActionRegistration> actionRegistrations,
    required this.onUnhandledActionType,
    required this.onFatalParsingError,
    required this.instrumentation,
  })  : parser = PushNotificationParser(actionRegistrations, instrumentation),
        executer = ActionExecutor(actionRegistrations) {
    assert(() {
      _checkForDuplicateActionTypeRegistrations(actionRegistrations);
      return true;
    }());
  }

  /// Tries to parse the [pushNotification] with the registered
  /// [actionRegistrations] and execute the corresponding [ActionRequest].
  ///
  /// Throws an [ArgumentError] if [pushNotification] is `null`.
  ///
  /// Might throw if [onUnhandledActionType] or [onFatalParsingError] throw an
  /// error (which they should not).
  ///
  /// Parsing failures or execution failures of an [ActionRequest] are
  /// automatically logged via the [instrumentation] and do not throw an error.
  Future<void> handlePushNotification(PushNotification pushNotification) async {
    ArgumentError.checkNotNull(pushNotification, 'pushNotification');
    instrumentation.startHandlingPushNotification(pushNotification);
    late ActionRequest actionRequest;

    try {
      actionRequest = parser.parseNotification(pushNotification);
      instrumentation.parsingSucceeded(pushNotification, actionRequest);
    } on UnknownActionTypeException {
      instrumentation.parsingFailedOnUnknownActionType(pushNotification);
      return onUnhandledActionType(pushNotification);
    } catch (e, s) {
      instrumentation.parsingFailedFataly(pushNotification, e, s);
      return onFatalParsingError(pushNotification, e);
    }

    try {
      executer.executeAction(actionRequest);
      instrumentation.actionExecutedSuccessfully(actionRequest);
    } catch (e, s) {
      instrumentation.actionExecutionFailed(actionRequest, e, s);
    }
  }
}

void _checkForDuplicateActionTypeRegistrations(
    List<ActionRegistration<ActionRequest>> actionRegistrations) {
  Set<ActionRegistration> allDuplicates = {};
  for (final registration in actionRegistrations) {
    final duplicates = registration.getDuplicates(actionRegistrations);
    if (duplicates.isNotEmpty) {
      allDuplicates.addAll([...duplicates, registration]);
    }
  }
  if (allDuplicates.isNotEmpty) {
    throw DuplicateRegistrationsError(allDuplicates);
  }
}

extension on ActionRegistration {
  bool hasIntersection(ActionRegistration other) => registerForActionTypeStrings
      .intersection(other.registerForActionTypeStrings)
      .isNotEmpty;

  Set<ActionRegistration> getDuplicates(
      List<ActionRegistration> registrations) {
    Set<ActionRegistration> duplicates = {};

    for (var registration in registrations.where((r) => r != this)) {
      if (hasIntersection(registration)) {
        duplicates.add(registration);
      }
    }
    return duplicates;
  }
}

class DuplicateRegistrationsError extends Error {
  final Set<ActionRegistration> duplicateRegistrations;

  DuplicateRegistrationsError(this.duplicateRegistrations);

  @override
  String toString() =>
      'Some $ActionRegistration have registered for the same action type string: $duplicateRegistrations.';
}
