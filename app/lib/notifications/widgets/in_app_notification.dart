// Ein Overlay, was dem Nutzer als anklickbare HeadsUp Notification angezeigt wird.
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

/// A In-App-Notification shown to the user inside the app.
/// Unlike a regular notification it will not appear inside the systems
/// notification.
///
/// It is used because our messaging service does not support showing
/// notifications while being inside the app so we have to handle this case
/// ourselves with this class.
class InAppNotification extends StatelessWidget {
  const InAppNotification({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.body,
  }) : super(key: key);

  /// Called when the user taps anywhere on the notification except the dismiss
  /// button. When [onTap] is called the notification will be removed from the
  /// widget tree automatically.
  ///
  /// For example [onTap] can be used to navigate to a homework item after a
  /// [InAppNotification] was shown to the user alerting him of a new comment
  /// on this homework.
  final VoidCallback onTap;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          OverlaySupportEntry.of(context).dismiss();
          onTap();
        },
        child: Card(
          margin: const EdgeInsets.all(6),
          child: SafeArea(
            child: ListTile(
              title: Text(title),
              subtitle: Text(body),
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
