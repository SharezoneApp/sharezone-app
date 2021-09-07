import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/logging/logging.dart';
import 'package:sharezone/main.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/notifications/push_notification_action_handler_instrumentation_implementation.dart';
import 'package:sharezone/notifications/setup_push_notification_action_handler.dart';
import 'package:sharezone/notifications/widgets/error_dialog.dart';
import 'package:sharezone/notifications/widgets/in_app_notification.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:sharezone/util/navigation_service.dart';

import 'action_requests/action_requests.dart';

class FirebaseMessagingCallbackConfigurator {
  final NavigationService navigationService;
  final NavigationBloc navigationBloc;

  FirebaseMessagingCallbackConfigurator({
    this.navigationService,
    this.navigationBloc,
  });

  Future<void> configureCallbacks(BuildContext context) async {
    /// Im Driver-Test kann der "willst du Notifikationen erhalten"-Dialog nicht
    /// geschlossen werden, weshalb wir diesen in einem Driver-Test auch nicht
    /// anzeigen wollen.
    if (!kIsDriverTest) _requestIOSPermission(context);

    final _logger = szLogger.makeChild('FirebaseMessagingCallbackConfigurator');

    _logger.fine(
        'Got Firebase Messaging token: ${await FirebaseMessaging.instance.getToken()}');

    final handler = _createNotificiationHandler(context);

    FirebaseMessaging.onMessage.listen((message) {
      final pushNotification = PushNotification.fromFirebase(message);
      showOverlayNotification(
          (context) => InAppNotification(
                title: pushNotification.title,
                body: pushNotification.body,
                onTap: () => handler.handlePushNotification(pushNotification),
              ),
          duration: const Duration(milliseconds: 6500));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final pushNotification = PushNotification.fromFirebase(message);
      handler.handlePushNotification(pushNotification);
    });
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

Future<void> _requestIOSPermission(BuildContext context) async {
  final signUpBloc = BlocProvider.of<SignUpBloc>(context);
  final signedUp = await signUpBloc.signedUp.first;

  // Falls der Nutzer sich nicht registriert hat, muss nach der Berechtigung
  // für die Push-Nachrichten gefragt werden, weil dies normalerweise im
  // Onboarding passiert. Meldet sich ein Nutzer mit einem Konto auf seinem
  // iPad an (zweit Gerät), würde dieser nicht die Abfrage für die Push-Nachrichten
  // erhalten und somit niemals Push-Nachricht zugeschickt bekommen.
  if (!signedUp) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }
}
