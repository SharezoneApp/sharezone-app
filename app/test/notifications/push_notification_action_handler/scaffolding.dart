// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/notifications/setup_push_notification_action_handler.dart';

/// Returns a [List] of [PushNotification] where every field that is set to one
/// of the given values.
///
/// Is used in tests so that one can test more mutations of a [PushNotification]
/// in a more concise way.
///
/// It doesn't go through all possible  mutations currently, but the first
/// mutation of all given values, then the second and so on. This excludes e.g.
/// the case of choosing the first mutation of one attribute, but the second of
/// another. Testing all possible mutations could be added in the futurrer but
/// might also lead to slow tests as there will be way more tests to run
/// (haven't been tried out yet).
///
/// Example: Notice that there are more notifications that could be generated
/// but are not. E.g. a notification with a title but no body.
/// dart```
/// final notifications = generateNotificationMutations(
///   actionType: {'do-something', 'do-something-aswell'},
///   actionData: {
///     <String, dynamic>{},
///     {'link': null},
///     {'link': ''},
///   },
///   title: {null, '', 'my title'},
///   body: {null, '', 'my body'},
/// );
///
/// expect(notifications, [
///   PushNotification(
///     actionType: 'do-something',
///     actionData: {},
///     title: null,
///     body: null,
///   ),
///   PushNotification(
///     actionType: 'do-something-aswell',
///     actionData: {'link': null},
///     title: '',
///     body: '',
///   ),
///   PushNotification(
///     actionType: 'do-something-aswell',
///     actionData: {'link': ''},
///     title: 'my title',
///     body: 'my body',
///   ),
/// ]);
/// ```
List<PushNotification> generateNotificationMutations({
  required dynamic actionType,
  required dynamic actionData,
  required dynamic title,
  required dynamic body,
}) {
  assert(actionType is String || actionType is Iterable<String>);
  assert(actionData is Map<String, dynamic> || actionData is Iterable<Map>);
  assert(title is String || title is Iterable<String>);
  assert(body is String || body is Iterable<String>);

  final actionTypeMutations = asList(actionType);
  final actionDataMutations = asList(actionData);
  final titleMutations = asList(title);
  final bodyMutations = asList(body);

  final allMutations = [
    actionTypeMutations,
    actionDataMutations,
    titleMutations,
    bodyMutations
  ];

  final lengthOfLongestMutationList =
      allMutations.map((list) => list.length).reduce((a, b) => max(a, b));

  final notifications = <PushNotification>[];

  for (var i = 0; i < lengthOfLongestMutationList; i++) {
    /// Gets the element for the current index [i] or the last element if the
    /// index would access an element outside of the list.
    /// Is used because the different attributes can have a diffently sized
    /// number of mutations.
    T _getElement<T>(List<T> list) => list[min(list.length - 1, i)];

    final _actionType = _getElement(actionTypeMutations);
    final _actionData = _getElement(actionDataMutations);
    final _title = _getElement(titleMutations);
    final _body = _getElement(bodyMutations);

    notifications.add(PushNotification(
      actionType: _actionType as String,
      title: _title as String,
      body: _body as String,
      actionData: _actionData as Map<String, dynamic>,
    ));
  }

  return notifications;
}

List asList(dynamic value) {
  if (value is List) {
    return value;
  }
  if (value is Set) {
    return value.toList();
  }
  return [value];
}

class TestHandlerFor {
  static void nonFatalParsingExceptions<T extends ActionRequest>({
    required List<PushNotification> Function() generateNotifications,
    required void Function(
            List<NonFatalParsingException> parsingExceptionsPerNotification)
        expectParsingErrors,
  }) {
    assert(T != dynamic, "ActionRequest type must be specified");

    for (final notification in generateNotifications()) {
      final result = handlePushNotification(notification);
      final actionRequest = result.actionRequestOrNull;
      if (actionRequest == null) {
        throw StateError(
            "The actionRequest was null. This shouldn't happen as we expect a successful execution here. The handler result was: $result.");
      }

      expect(actionRequest, isA<T>(),
          reason: '$notification should get matched to a $T.');

      final parsingExceptions = result.nonFatalParsingExceptions!;

      if (parsingExceptions.isEmpty) {
        throw StateError(
            "The parsingExceptions are empty. This shouldn't happen as we expect parsingExceptions here. The handler result was: $result.");
      }

      expectParsingErrors(parsingExceptions);
    }
  }

  static void success<T extends ActionRequest>({
    required List<PushNotification> Function() generateNotifications,
    required void Function(T intent) expectActionToExecute,
    bool failOnNonFatalParsingErrors = false,
    List<ActionRegistration> addRegistrations = const [],
  }) {
    assert(T != dynamic, "ActionRequest type must be specified");

    for (final notification in generateNotifications()) {
      final result = handlePushNotification(notification,
          testRegistrations: addRegistrations);

      if (failOnNonFatalParsingErrors &&
          result.nonFatalParsingExceptions!.isNotEmpty) {
        throw StateError(
            "Result had non-fatal parsing errors (`failOnNonFatalParsingErrors` options was true). The handler result was: $result.");
      }

      final actionRequest = result.actionRequestOrNull;
      if (actionRequest == null) {
        throw StateError(
            "The actionRequest was null. This shouldn't happen as we expect a successful execution here. The handler result was: $result.");
      }

      expect(actionRequest, isA<T>(),
          reason: '$notification should get matched to a $T.');

      expectActionToExecute(actionRequest as T);
    }
  }

  static void fatalParsingFailure({
    required List<PushNotification> Function() generateNotifications,
    required void Function(FatalParsingError? error) resultsInFatalParsingError,
    List<ActionRegistration> addRegistrations = const [],
  }) {
    for (final notification in generateNotifications()) {
      final result = handlePushNotification(notification,
          testRegistrations: addRegistrations);

      if (result.fatalParsingExceptionOrNull == null) {
        throw StateError(
            "The fatal parsing exception was null. This shouldn't happen as we expect a fatal error here. The handler result was: $result.");
      }

      resultsInFatalParsingError(result.fatalParsingExceptionOrNull);
    }
  }

  static void errorDialog({
    required List<PushNotification> Function() generateNotifications,
    required void Function(ShowErrorDialogInvocation? showErrorDialogException)
        shouldShowErrorDialog,
    List<ActionRegistration> addRegistrations = const [],
  }) {
    for (final notification in generateNotifications()) {
      final result = handlePushNotification(notification,
          testRegistrations: addRegistrations);

      if (result.showErrorDialogExceptionOrNull == null) {
        throw StateError(
            "The fatal parsing exception was null. This shouldn't happen as we expect a fatal error here. The handler result was: $result.");
      }

      shouldShowErrorDialog(result.showErrorDialogExceptionOrNull);
    }
  }
}

/// A class to make the [PushNotificationActionHandler] more testable.
/// In this way all side-effects are contained in this class which makes it more
/// accessible.
class PushHandlerInvocationResult {
  final ActionRequest? actionRequestOrNull;
  final PushNotification? notification;
  final List<NonFatalParsingException>? nonFatalParsingExceptions;
  final FatalParsingError? fatalParsingExceptionOrNull;
  final TestInstrumentation? instrumentation;

  /// This should only be used for [TestHandlerFor.errorDialog].
  ///
  /// This invocation constitutes a concern of the "outer layer" (for in-app use
  /// pre-configured [PushNotificationActionHandler]) of the app but not the generic
  /// logic inside the [PushNotificationActionHandler].
  ///
  /// As all other test scaffolds in [TestHandlerFor] are concerned with the
  /// generic logic ("inner layer") they shouldn't use this.
  final ShowErrorDialogInvocation? showErrorDialogExceptionOrNull;

  PushHandlerInvocationResult({
    this.actionRequestOrNull,
    this.notification,
    this.nonFatalParsingExceptions,
    this.fatalParsingExceptionOrNull,
    this.showErrorDialogExceptionOrNull,
    this.instrumentation,
  });

  @override
  String toString() {
    return 'PushHandlerInvocationResult(actionRequestOrNull: $actionRequestOrNull, notification: $notification, nonFatalParsingExceptions: $nonFatalParsingExceptions, fatalParsingExceptionOrNull: $fatalParsingExceptionOrNull, showErrorDialogExceptionOrNull: $showErrorDialogExceptionOrNull)';
  }
}

PushHandlerInvocationResult handlePushNotification(
  PushNotification pushNotification, {
  List<ActionRegistration> testRegistrations = const [],
}) {
  final instrumentation = TestInstrumentation();

  ActionRequest? actionRequest;
  void handle(ActionRequest request) {
    actionRequest = request;
  }

  ShowErrorDialogInvocation? showErrorDialogException;

  final handler = setupPushNotificationActionHandler(
    navigateToLocation: handle,
    openLink: handle,
    showBlackboardItem: handle,
    showHomework: handle,
    showNotificationDialog: handle,
    showTimetableEvent: handle,
    showErrorNotificationDialog: (notification, errorReason, error) =>
        showErrorDialogException =
            ShowErrorDialogInvocation(notification, errorReason, error),
    testRegistrations: testRegistrations,
    instrumentation: instrumentation,
  );

  handler.handlePushNotification(pushNotification);

  return PushHandlerInvocationResult(
    actionRequestOrNull: actionRequest,
    notification: pushNotification,
    showErrorDialogExceptionOrNull: showErrorDialogException,
    instrumentation: instrumentation,
    nonFatalParsingExceptions: instrumentation.nonFatalParsingExceptions,
    fatalParsingExceptionOrNull: instrumentation.fatalParsingError,
  );
}

class ShowErrorDialogInvocation implements Exception {
  final PushNotification notification;
  final NotificationHandlerErrorReason errorReason;
  final dynamic errorOrNull;

  ShowErrorDialogInvocation(
      this.notification, this.errorReason, this.errorOrNull);
}

class FatalParsingError {
  final PushNotification notification;
  final dynamic error;
  final StackTrace stackTrace;

  FatalParsingError({
    required this.notification,
    required this.error,
    required this.stackTrace,
  }) {
    ArgumentError.checkNotNull(notification, 'notification');
    ArgumentError.checkNotNull(error, 'error');
  }
}

class NonFatalParsingException implements Exception {
  final String attributeName;
  final dynamic fallbackValueChosen;
  final PushNotification? notification;
  final dynamic error;

  NonFatalParsingException({
    required this.attributeName,
    required this.fallbackValueChosen,
    required this.notification,
    required this.error,
  });
}

class TestInstrumentation
    implements PushNotificationActionHandlerInstrumentation {
  List<NonFatalParsingException> nonFatalParsingExceptions = [];
  bool get hasNonFatalParsingExceptions => nonFatalParsingExceptions.isNotEmpty;

  FatalParsingError? fatalParsingError;
  bool get hasFatalParsingError => fatalParsingError != null;

  dynamic fatalConversionException;
  bool get hasFatalConversionException => fatalConversionException != null;

  bool hasFailedOnUnknownActionType = false;

  @override
  void parsingFailedFataly(
      PushNotification pushNotification, exception, StackTrace stacktrace) {
    fatalConversionException = exception;
    fatalParsingError = FatalParsingError(
      error: exception,
      notification: pushNotification,
      stackTrace: stacktrace,
    );
  }

  bool calledHandlingPushNotification = false;
  @override
  void startHandlingPushNotification(PushNotification pushNotification) {
    calledHandlingPushNotification = true;
  }

  bool calledActionExecutionFailed = false;
  @override
  void actionExecutionFailed(
      ActionRequest actionRequest, exception, StackTrace stacktrace) {
    calledActionExecutionFailed = true;
  }

  bool calledParsingSucceeded = false;
  @override
  void parsingSucceeded(
      PushNotification pushNotification, ActionRequest actionRequest) {
    calledParsingSucceeded = true;
  }

  bool calledActionExecutedSuccessfully = false;

  @override
  void actionExecutedSuccessfully(ActionRequest actionRequest) {
    calledActionExecutedSuccessfully = true;
  }

  @override
  void parsingFailedOnUnknownActionType(PushNotification pushNotification) {
    hasFailedOnUnknownActionType = true;
  }

  @override
  void parsingFailedNonFatalyOnAttribute(String attributeName,
      {dynamic fallbackValueChosenInstead,
      PushNotification? notification,
      dynamic error}) {
    nonFatalParsingExceptions.add(
      NonFatalParsingException(
          attributeName: attributeName,
          fallbackValueChosen: fallbackValueChosenInstead,
          notification: notification,
          error: error),
    );
  }
}
