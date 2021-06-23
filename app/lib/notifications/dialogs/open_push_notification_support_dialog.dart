import 'package:flutter/widgets.dart';
import 'package:sharezone/notifications/models/push_notification.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';

import 'package:url_launcher_extended/url_launcher_extended.dart';

void openPushNotificationSupportDialog(
    BuildContext context, PushNotifaction notifaction) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final confiremd = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      title: notifaction.title,
      content: notifaction.hasBody ? Text(notifaction.body) : null,
      defaultValue: false,
      right: AdaptiveDialogAction<bool>(
        isDefaultAction: true,
        popResult: true,
        title: "Antworten",
      ),
    );
    if (confiremd) {
      UrlLauncherExtended().tryLaunchMailOrThrow(
        "support@sharezone.net",
        subject: 'Rückmeldung zur Support-Notifaction',
        body:
            'Liebes Sharezone-Team,\n\nihr habt folgende Nachricht geschreiben:\n${notifaction.title}; ${notifaction.body}\n\nMein Anliegen:\n_',
      );
    }
  });
}
