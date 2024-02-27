// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class CourseTileBase extends StatelessWidget {
  final String? courseName;
  final String? errorText;

  /// If null disables tile.
  final VoidCallback? onTap;

  const CourseTileBase({
    required this.courseName,
    required this.errorText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      title: const Text("Kurs"),
      subtitle: Text(
        errorText ?? courseName ?? "Keinen Kurs ausgewählt",
        style: errorText != null ? const TextStyle(color: Colors.red) : null,
      ),
      trailing: const Icon(Icons.keyboard_arrow_down),
      enabled: onTap != null,
      onTap: () => onTap!(),
    );
  }
}
