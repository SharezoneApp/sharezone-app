// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:notifications/notifications.dart';

@internal
class PushNotificationParserInstrumentationFactory {
  final PushNotificationActionHandlerInstrumentation _instrumentation;

  PushNotificationParserInstrumentationFactory(this._instrumentation);

  PushNotificationParserInstrumentation forNotification(
      PushNotification notification) {
    return PushNotificationParserInstrumentation(
        _instrumentation, notification);
  }
}

/// Instrumentation used inside
/// [ActionRegistration.parseActionRequestFromNotification] to notify of
/// non-fatal parsing failures via [parseAttributeOrLogFailure].
///
/// Example:
/// ```dart
/// ShowNotificationDialogRequest _toShowNotificationDialogActionRequest(
///     PushNotification notification,
///     [PushNotificationParserInstrumentation instrumentation]) {
///
///   final showSupportOption = instrumentation.parseAttributeOrLogFailure(
///     'showSupportOption',
///     fallbackValue: false,
///     parse: () {
///       return notification.actionData['showSupportOption'] as bool;
///     },
///   );
///
///   return ShowNotificationDialogRequest(
///     notification.title,
///     notification.body,
///     shouldShowAnswerToSupportOption: showSupportOption,
///   );
/// }
class PushNotificationParserInstrumentation {
  final PushNotificationActionHandlerInstrumentation _instrumentation;
  final PushNotification _currentNotification;

  PushNotificationParserInstrumentation(
      this._instrumentation, this._currentNotification);

  /// A method to parse a value called [attributeName] of type [T] which will
  /// automatically call [parsingFailedNonFatalyOnAttribute] if [parse] throws
  /// an error. If [parse] returns `null` then [fallbackValue] will be returned.
  ///
  /// [fallbackValue] must not be `null`.
  ///
  /// ```dart
  ///   final showSupportOption = instrumentation.parseAttributeOrLogFailure(
  ///     'showSupportOption',
  ///     fallbackValue: false,
  ///     parse: () {
  ///       return notification.actionData['showSupportOption'] as bool;
  ///     },
  ///   );
  /// ```
  T parseAttributeOrLogFailure<T>(
    String attributeName, {
    required T Function() parse,
    required T fallbackValue,
  }) {
    try {
      final result = parse();
      if (result == null) {
        return fallbackValue;
      }
      return result;
    } catch (e) {
      parsingFailedNonFatalyOnAttribute(attributeName,
          error: e, fallbackValueChosenInstead: fallbackValue);
      return fallbackValue;
    }
  }

  /// Notify that an attribute named [attributeName] couldn't be parsed and that
  /// instead [fallbackValueChosenInstead] was chosen instead. [error] is the
  /// error that was raised when trying to read the original (faulty) attribute
  /// from the [PushNotification].
  ///
  /// Can be used via [parseAttributeOrLogFailure] more easily.
  void parsingFailedNonFatalyOnAttribute(
    String attributeName, {
    dynamic fallbackValueChosenInstead,
    dynamic error,
  }) {
    _instrumentation.parsingFailedNonFatalyOnAttribute(
      attributeName,
      fallbackValueChosenInstead: fallbackValueChosenInstead,
      error: error,
      notification: _currentNotification,
    );
  }
}

/// A place to add logging, analytics or performance metrics for the
/// [PushNotificationActionHandler].
///
/// Example:
/// ```dart
/// class MyLoggingPushNotificationActionHandlerInstrumentation extends PushNotificationActionHandlerInstrumentation {
///   final Logger logger = Logger('PushNotificationActionHandler');
///
///  @override
///   void parsingFailedFataly(
///     PushNotification pushNotification,
///     dynamic exception,
///     StackTrace stacktrace,
///   ) {
///       logger.severe(
///         'Parsing notification $pushNotification failed fataly.',
///         exception,
///         stacktrace,
///       );
///     }
///
///   /// ....
///
/// }
///
/// ```
abstract class PushNotificationActionHandlerInstrumentation {
  /// The [PushNotificationActionHandler] has started handling the [pushNotification].
  /// Called at the start the [pushNotification] gets actually handled.
  void startHandlingPushNotification(PushNotification pushNotification);

  /// Parsing the attribute called [attributeName] from [notification] failed
  /// because of [error]. The value [fallbackValueChosenInstead] was used
  /// instead.
  ///
  /// If failing to parse the attribute is non recoverable then
  /// [parsingFailedFataly] should be used instead.
  void parsingFailedNonFatalyOnAttribute(
    String attributeName, {
    dynamic fallbackValueChosenInstead,
    required PushNotification notification,
    dynamic error,
  });

  /// There was no [ActionRegistration] registrated for the
  /// [PushNotification.actionType] of [pushNotification].
  void parsingFailedOnUnknownActionType(PushNotification pushNotification);

  /// Failed to parse a [ActionRequest] from the [pushNotification].
  ///
  /// This might happen if an attribute (e.g. `messageText` for a `ShowMessage`
  /// `ActionRequest`) could not be parsed and the parsing error is
  /// non-recoverable (no fallback value could be used).\
  ///
  /// If the parsing error can recovered from then
  /// [parsingFailedNonFatalyOnAttribute] should be used instead.
  void parsingFailedFataly(
    PushNotification pushNotification,
    dynamic exception,
    StackTrace stacktrace,
  );

  /// Successfully parsed the [actionRequest] from the [pushNotification].
  void parsingSucceeded(
      PushNotification pushNotification, ActionRequest actionRequest);

  /// Failed to execute the [actionRequest].
  void actionExecutionFailed(
      ActionRequest actionRequest, dynamic exception, StackTrace stacktrace);

  /// Successfully executed the [actionRequest].
  void actionExecutedSuccessfully(ActionRequest actionRequest);
}
