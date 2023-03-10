// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/logging/logging.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/notifications/logic/notifications_permission_bloc.dart';
import 'package:sharezone/notifications/push_notification_action_handler_instrumentation_implementation.dart';
import 'package:sharezone/notifications/setup_push_notification_action_handler.dart';
import 'package:sharezone/notifications/widgets/error_dialog.dart';
import 'package:sharezone/notifications/widgets/in_app_notification.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_utils/device_information_manager.dart';

import 'action_requests/action_requests.dart';

class FirebaseMessagingCallbackConfigurator {
  final NavigationService navigationService;
  final NavigationBloc navigationBloc;
  final AndroidDeviceInformation androidDeviceInformation;

  FirebaseMessagingCallbackConfigurator({
    this.navigationService,
    this.navigationBloc,
    this.androidDeviceInformation,
  });

  Future<void> configureCallbacks(BuildContext context) async {
    _requestPermissionIfNeeded(context);

    final _logger = szLogger.makeChild('FirebaseMessagingCallbackConfigurator');

    _logger.fine(
        'Got Firebase Messaging token: ${await FirebaseMessaging.instance.getToken()}');

    final handler = _createNotificiationHandler(context);

    void handleFcmMessage(
      RemoteMessage message, {
      bool showInAppNotification = false,
    }) {
      final pushNotification = PushNotification.fromFirebase(message);
      if (showInAppNotification) {
        showOverlayNotification(
            (context) => InAppNotification(
                  title: pushNotification.title,
                  body: pushNotification.body,
                  onTap: () => handler.handlePushNotification(pushNotification),
                ),
            duration: const Duration(milliseconds: 6500));
      } else {
        handler.handlePushNotification(pushNotification);
      }
    }

    FirebaseMessaging.onMessage.listen((message) {
      // App is open in the foreground.
      //
      // We display an in-app notification at the top of the screen as the
      // notification won't be shown in the system notification tray because
      // the user is already inside the app.
      handleFcmMessage(message, showInAppNotification: true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      /// App is open in the background.
      ///
      /// The notification is received inside the system notification tray. This
      /// code will execute if the user taps on the notification, thus we don't
      /// need to display it a second time with an in-app notification.
      handleFcmMessage(message, showInAppNotification: false);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      /// App was closed / terminated (not running in the background).
      ///
      /// The notification is received inside the system notification tray. This
      /// code will execute if the user taps on the notification, thus we don't
      /// need to display it a second time with an in-app notification.
      handleFcmMessage(initialMessage, showInAppNotification: false);
    }
  }

  PushNotificationActionHandler _createNotificiationHandler(
      BuildContext context) {
    BuildContext getContext() => navigationService.navigatorKey.currentContext;
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final timetableGateway = api.timetable;
    final courseGateway = api.course;

    final notificationHandlerLogger =
        szLogger.makeChild('PushNotificationActionHandler');
    final handler = setupPushNotificationActionHandler(
      navigateToLocation:
          NavigateToLocationExecutor(navigationBloc, navigationService).execute,
      openLink: OpenLinkExecutor(getContext).execute,
      showBlackboardItem: ShowBlackboardItemExecutor(navigationService).execute,
      showHomework: ShowHomeworkExecutor(navigationService).execute,
      showNotificationDialog:
          ShowNotificationDialogExecutor(getContext).execute,
      showTimetableEvent: ShowTimetableEventExecutor(
              getContext, timetableGateway, courseGateway)
          .execute,
      showErrorNotificationDialog: (notification, errorReason, error) {
        showNotificationHandlingErrorDialog(notification, errorReason,
            context: getContext());
      },
      instrumentation: PushNotificationActionHandlerInstrumentationImpl(
          notificationHandlerLogger),
    );

    return handler;
  }
}

/// Prompts the native iOS permissions dialog to ask the user if we are allowed
/// to send push notifications.
///
/// Does nothing if the platform is not iOS.
Future<void> _requestPermissionIfNeeded(BuildContext context) async {
  final notificationsPermission = Provider.of<NotificationsPermission>(context);
  final isNeeded =
      await notificationsPermission.isRequiredToRequestPermission();
  if (!isNeeded) {
    return;
  }

  final signUpBloc = BlocProvider.of<SignUpBloc>(context);
  final signedUp = await signUpBloc.signedUp.first;

  // Falls der Nutzer sich nicht registriert hat, muss nach der Berechtigung
  // für die Push-Nachrichten gefragt werden, weil dies normalerweise im
  // Onboarding passiert. Meldet sich ein Nutzer mit einem Konto auf seinem
  // iPad an (zweit Gerät), würde dieser nicht die Abfrage für die Push-Nachrichten
  // erhalten und somit niemals Push-Nachricht zugeschickt bekommen.
  if (!signedUp) {
    await notificationsPermission.requestPermission();
  }
}
