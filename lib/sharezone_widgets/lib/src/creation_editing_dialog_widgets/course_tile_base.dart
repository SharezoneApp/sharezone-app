// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CourseTileBase extends StatelessWidget {
  final String? courseName;
  final String? errorText;

  /// The text to display in a dialog when [onTap] is `null` and the user taps
  /// on the tile.
  ///
  /// Normally this is used to indicate that the user can't change the course
  /// and should should delete the item instead.
  ///
  /// If [onDisabledTapText] and [onTap] is null, nothing happens when the user
  /// taps on the tile. If [onTap] is not null, [onDisabledTapText] is ignored.
  final String? onDisabledTapText;

  /// If null disables tile.
  final VoidCallback? onTap;

  const CourseTileBase({
    required this.courseName,
    required this.errorText,
    required this.onTap,
    this.onDisabledTapText,
    super.key,
  });

  void showDisabledNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DisabledNoteDialog(text: onDisabledTapText!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap != null || onDisabledTapText == null
              ? null
              : () => showDisabledNoteDialog(context),
      child: ListTile(
        leading: const Icon(Icons.book),
        title: const Text("Kurs"),
        subtitle: Text(
          errorText ?? courseName ?? "Keinen Kurs ausgewählt",
          style: errorText != null ? const TextStyle(color: Colors.red) : null,
        ),
        trailing: const Icon(Icons.keyboard_arrow_down),
        enabled: onTap != null,
        onTap: () => onTap!(),
      ),
    );
  }
}

class DisabledNoteDialog extends StatelessWidget {
  const DisabledNoteDialog({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text("Hinweis"),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
