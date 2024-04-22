// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_plus_page_ui/src/styled_markdown_text.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// A dialog that is shown when buying Sharezone Plus failed.
class BuyingFailedDialog extends StatelessWidget {
  const BuyingFailedDialog({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text("Kaufen fehlgeschlagen"),
        content: SingleChildScrollView(
          child: StyledMarkdownText(
            text:
                "Der Kauf von Sharezone Plus ist fehlgeschlagen. Bitte versuche es später erneut.\n\nFehler: $error\n\nBei Fragen wende dich an [plus@sharezone.net](mailto:plus@sharezone.net).",
            alignment: WrapAlignment.start,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          FilledButton(
            onPressed: () async {
              const email = 'plus@sharezone.net';
              await launchUrl(Uri.parse('mailto:$email'));
            },
            child: const Text('Support kontaktieren'),
          ),
        ],
      ),
    );
  }
}
