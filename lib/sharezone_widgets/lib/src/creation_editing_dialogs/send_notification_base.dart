import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SendNotificationBase extends StatelessWidget {
  const SendNotificationBase({
    super.key,
    required this.title,
    required this.sendNotification,
    required this.onChanged,
    this.listTileKey,
    this.switchKey,
    this.description,
  });

  final String title;
  final String? description;
  final bool sendNotification;
  final Function(bool) onChanged;
  final Key? listTileKey;
  final Key? switchKey;

  @override
  Widget build(BuildContext context) {
    return ListTileWithDescription(
      key: listTileKey,
      leading: const Icon(Icons.notifications_active),
      title: Text(title),
      trailing: Switch.adaptive(
        key: switchKey,
        onChanged: onChanged,
        value: sendNotification,
      ),
      onTap: () => onChanged(!sendNotification),
      description: description != null ? Text(description!) : null,
    );
  }
}
