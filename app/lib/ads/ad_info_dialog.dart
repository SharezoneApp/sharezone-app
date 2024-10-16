// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void showAdInfoDialog(BuildContext context) async {
  final navigateToPlusPage = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => const _Dialog(),
  );

  if (navigateToPlusPage == true && context.mounted) {
    navigateToSharezonePlusPage(context);
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog();

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 500,
      child: AlertDialog(
        title: const Text('Werbung in Sharezone'),
        content: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text:
                    'Innerhalb der nächsten Wochen führen wir ein Experiment mit Werbung in Sharezone durch. Wenn du keine Werbung sehen möchten, kannst du ',
              ),
              TextSpan(
                text: 'Sharezone Plus',
                style: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).pop(true),
              ),
              const TextSpan(
                text: ' erwerben.',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
