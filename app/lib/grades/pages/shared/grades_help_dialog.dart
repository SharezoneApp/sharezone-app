// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// A dialog for the grades feature
class GradesHelpDialog extends StatelessWidget {
  const GradesHelpDialog({super.key, required this.title, required this.text});

  final Widget title;
  final Widget text;

  static void show(BuildContext context, Widget widget) {
    showDialog(context: context, builder: (context) => widget);
  }

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 550,
      child: AlertDialog(
        title: title,
        content: SingleChildScrollView(child: text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonActionsOk),
          ),
        ],
      ),
    );
  }
}
