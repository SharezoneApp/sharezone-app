// Ein Overlay, was dem Nutzer als anklickbare HeadsUp Notification angezeigt wird.
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/notifications/models/push_notification.dart';
import 'package:sharezone/util/navigation_service.dart';

import '../push_notification_action.dart';

class InAppNotification extends StatelessWidget {
  const InAppNotification(
      {Key key,
      @required this.notification,
      @required this.navigationService,
      @required this.navigationBloc})
      : super(key: key);

  final PushNotifaction notification;
  final NavigationService navigationService;
  final NavigationBloc navigationBloc;

  @override
  Widget build(BuildContext context) {
    print(notification.toString());
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: notification.hasID
            ? () {
                OverlaySupportEntry.of(context).dismiss();
                final actionHandler = PushNotificationActionHandler(
                  navigationBloc: navigationBloc,
                  navigationService: navigationService,
                );
                actionHandler.launchNotificationAction(context, notification);
              }
            : null,
        child: Card(
          margin: const EdgeInsets.all(6),
          child: SafeArea(
            child: ListTile(
              title: notification.hasTitle ? Text(notification.title) : null,
              subtitle: notification.hasBody ? Text(notification.body) : null,
              trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => OverlaySupportEntry.of(context).dismiss()),
            ),
          ),
        ),
      ),
    );
  }
}
