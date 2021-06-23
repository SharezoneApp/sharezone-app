import 'package:flutter/widgets.dart';
import 'package:sharezone/notifications/models/push_notification.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';

void openPushNotificationTextDialog(
    BuildContext context, PushNotifaction notifaction) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    showLeftRightAdaptiveDialog<bool>(
      context: context,
      title: notifaction.title,
      content: notifaction.hasBody ? Text(notifaction.body) : null,
      defaultValue: false,
      left: AdaptiveDialogAction<bool>(
        isDefaultAction: true,
        title: "Ok",
      ),
    );
  });
}
