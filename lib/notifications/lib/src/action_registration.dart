// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:notifications/notifications.dart';
import 'package:notifications/src/action_executor.dart';

/// Executes an [ActionRequest] ([T]).
///
/// If the [actionRequest] can't be executed this function should throw an
/// exception.
///
/// Example: If the [ActionRequest] is `ShowDialog` this function should
/// actually display the dialog and use the information in [actionRequest] (e.g.
/// `ShowDialog.title` and `ShowDialog.body`).
///
/// Is usually implemented by a subclass of [ActionExecutor].
typedef FutureOr<void> ActionRequestExecutorFunc<T extends ActionRequest>(
    T actionRequest);

/// Parse the [ActionRequest] of type [T] from the [notification] and
/// report non-fatal errors via the [instrumentation].
///
/// If no [ActionRequest] of type [T] can be parsed from the [notification] this
/// function should throw an [Exception].
///
/// For an example see documentation of [ActionRegistration].
typedef PushNotificationParsingFunc<T extends ActionRequest> = T Function(
  PushNotification notification,
  PushNotificationParserInstrumentation instrumentation,
);

/// Register a thing to happen (action) for a [PushNotification] with a specific
/// [PushNotification.actionType] (including none, see
/// [ActionRegistration.registerForActionTypeStrings]).
///
/// Example:
///
/// The following can be used so that every time a [PushNotification] with the
/// [PushNotification.actionType] being `print-string` or `print-my-string` is
/// received the [PushNotificationActionHandler] will print the given string.
///
/// ```dart
/// class PrintMyString extends ActionRequest {
///   final String stringToPrint;
///
///   PrintMyString(this.stringToPrint);
///
///   @override
///   List<Object> get props => [stringToPrint];
/// }
///
/// final myRegistration = ActionRegistration<PrintMyString>(
///   registerForActionTypeStrings: {'print-string', 'print-my-string'},
///   parseActionRequestFromNotification: (notification, instrumentation) {
///     return PrintMyString(notification.actionData['string-to-print'] ?? '');
///   },
///   executeActionRequest: (request) {
///     print(request.stringToPrint);
///   },
/// );
/// ```
class ActionRegistration<T extends ActionRequest> {
  /// Controls on which action type strings this action should be registered.
  ///
  /// If [registerForActionTypeStrings] contains an empty String it will be
  /// invoked for notifications that have either no (null) or an empty ('')
  /// action type string.
  final Set<String> registerForActionTypeStrings;

  /// See documentation of [PushNotificationParsingFunc].
  final PushNotificationParsingFunc<T> parseActionRequestFromNotification;

  /// See documentation of [ActionRequestExecutorFunc].
  final ActionRequestExecutorFunc<T> executeActionRequest;

  /// Convenience Function for all places that accept an [ActionRegistration]
  /// with [T] equals [ActionRequest] (the abstract superclass). In these cases
  /// calling [executeActionRequest] will result in the error
  /// ```
  /// type '(MyActionRequest) => Null' is not a subtype of type '(ActionRequest) => void'
  /// ```
  ///
  /// The problem here is that an abstract [ActionRequest] is expected but a
  /// specific instance is given. The type system doesn't accept a subclass
  /// here.
  ///
  /// In these cases we need to use a generic `Function` instead. As the type of
  /// [executeActionRequest] is checked anyways when instantiating this class
  /// the lost type safety shouldn't matter.
  ///
  /// For example [PushNotificationActionHandler.fromRegistrations] accepts a
  /// `List<ActionRegistration>` which means that it doesn't know the specific
  /// [ActionRequest] types [T] for all [ActionRegistration]. Thus it uses this
  /// method.
  Function get executeActionRequestCasted => executeActionRequest;

  /// The type of [ActionRequest] that this [ActionRegistration] registers.
  /// E.g. `ShowHomework`.
  Type get actionRequestType => T;

  /// Creates a new [ActionRegistration] that can passed to the constructor of
  /// [PushNotificationActionHandler].
  ///
  /// - [T] must be a subclass of [ActionRequest].
  /// - [registerForActionTypeStrings] can't be empty.
  /// - [registerForActionTypeStrings] can't contain `null`.\
  ///   An [ActionRegistration] for an empty [PushNotification.actionType] can
  ///   be registered by passing an empty string into
  ///   [registerForActionTypeStrings].
  ActionRegistration({
    @required this.registerForActionTypeStrings,
    @required this.parseActionRequestFromNotification,
    @required this.executeActionRequest,
  }) {
    assert(T is! ActionRequest,
        '$ActionRegistration requires T to be a subclass of $ActionRequest');

    if (registerForActionTypeStrings.isEmpty) {
      throw ArgumentError("The registered actionType Strings can't be empty.");
    }
    if (registerForActionTypeStrings.contains(null)) {
      throw ArgumentError(
          "'null' can't be registered as an action type string. If the action should be invoked on a notification without an action type string (null or '') then register this action for an empty action type string instead ('').");
    }
  }

  @override
  String toString() =>
      'ActionRegistration(actionTypeStrings: $registerForActionTypeStrings, actionRequestType: $actionRequestType)';
}

/// This is a convenience class that can be extended to implement the
/// [ActionRegistration.executeActionRequest] part. This is not technically
/// needed, just an element that can be used for a similar structure between the
/// actions.
abstract class ActionRequestExecutor<T extends ActionRequest> {
  FutureOr<void> execute(T actionRequest);
}
