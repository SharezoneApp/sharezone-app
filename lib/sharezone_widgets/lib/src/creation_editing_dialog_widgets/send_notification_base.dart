// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

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
    return ListTile(
      key: listTileKey,
      leading: const Icon(Icons.notifications_active),
      title: Text(title),
      trailing: Switch.adaptive(
        key: switchKey,
        onChanged: onChanged,
        value: sendNotification,
      ),
      onTap: () => onChanged(!sendNotification),
      subtitle: description != null ? Text(description!) : null,
    );
  }
}
