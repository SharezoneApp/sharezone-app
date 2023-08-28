// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:notifications/notifications.dart';
import 'package:sharezone/notifications/widgets/error_dialog.dart';

import 'action_requests/action_requests.dart';

/// The known / foreseeable ways the [PushNotificationActionHandler] can fail to
/// handle a [PushNotification].
///
/// Is used by [showNotificationHandlingErrorDialog].
enum NotificationHandlerErrorReason {
  /// The [PushNotification.actionType] wasn't handled by any
  /// [ActionRegistration].
  ///
  /// Might happen because either we sent a bad notification with a non-existing
  /// [PushNotification.actionType] to the clients (unlikely, but might happen)
  /// or because the client is old and doesn't yet recognize a newly added
  /// [PushNotification.actionType].
  unknownActionType,

  /// Parsing the [PushNotification] failed in a fatal way.
  ///
  /// Might happen because we sent a malformed [PushNotification] or we forgot
  /// to handle an edge-case inside
  /// [ActionRegistration.parseActionRequestFromNotification].\
  /// In short: we probably f****ed up ;p.
  fatalParsingError,
}

/// Creates the configured version of the [PushNotificationActionHandler] that is used
/// by us.
///
/// This setup is shared between tests and the app usage thus all important
/// side-effects (executing the actions, instrumentations, etc.) are injected
/// here for easy swap-out for testing.\
/// We still try to pre-configure as much as possible so that the overlap
/// between tests and real usage is greatest. This is why we don't just pass a
/// list of [ActionRegistration].
PushNotificationActionHandler setupPushNotificationActionHandler({
  required ActionRequestExecutorFunc<NavigateToLocationRequest>
      navigateToLocation,
  required ActionRequestExecutorFunc<OpenLinkRequest> openLink,
  required ActionRequestExecutorFunc<ShowBlackboardItemRequest>
      showBlackboardItem,
  required ActionRequestExecutorFunc<ShowHomeworkRequest> showHomework,
  required ActionRequestExecutorFunc<ShowNotificationDialogRequest>
      showNotificationDialog,
  required ActionRequestExecutorFunc<ShowTimetableEventRequest>
      showTimetableEvent,

  /// [errorOrNull] is non-null if [NotificationHandlerErrorReason] == [NotificationHandlerErrorReason.fatalParsingError]
  required void Function(
          PushNotification, NotificationHandlerErrorReason, dynamic errorOrNull)
      showErrorNotificationDialog,
  required PushNotificationActionHandlerInstrumentation instrumentation,
  @visibleForTesting List<ActionRegistration> testRegistrations = const [],
}) {
  final showNotificationDialogRegistration =
      showNotificationDialogRegistrationWith(showNotificationDialog);
  // We assume in [onUnknownActionType] below that we always have an action type
  // as this registration will handle all notifications without any action type.
  // This is just a safeguard for a developer error.
  assert(
    showNotificationDialogRegistration.registerForActionTypeStrings
        .contains(''),
  );

  return PushNotificationActionHandler(
    actionRegistrations: [
      navigateToLocationRegistrationWith(navigateToLocation),
      openLinkRegistrationWith(openLink),
      showBlackboardItemRegistrationWith(showBlackboardItem),
      showHomeworkRegistrationWith(showHomework),
      showTimetableEventRegistrationWith(showTimetableEvent),
      showNotificationDialogRegistrationWith(showNotificationDialog),
      ...testRegistrations,
    ],
    onUnhandledActionType: (notification) {
      /// Right here there should always be an action type.
      ///
      /// We handle a notification with content but no action type via the
      /// [showNotificationDialogRegistration].
      ///
      /// If there is no action type and no content the
      /// [PushNotificationActionHandler] should do nothing which is it's normal
      /// behavior for this case.
      assert(notification.hasActionType);

      /// There is a action type but we just don't know what to do.
      /// This might happen on an old client where a new action type isn't known
      /// yet.
      showErrorNotificationDialog(
          notification, NotificationHandlerErrorReason.unknownActionType, null);
    },
    onFatalParsingError: (notification, error) => showErrorNotificationDialog(
        notification, NotificationHandlerErrorReason.fatalParsingError, error),
    instrumentation: instrumentation,
  );
}
