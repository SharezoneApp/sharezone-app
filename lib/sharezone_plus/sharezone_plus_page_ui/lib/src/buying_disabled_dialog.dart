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

/// A dialog that is shown when the user tries to buy Sharezone Plus but the
/// buying process is disabled (e.g. during maintenance).
class BuyingDisabledDialog extends StatelessWidget {
  const BuyingDisabledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text("Kaufen deaktiviert"),
        content: const StyledMarkdownText(
          text:
              "Der Kauf von Sharezone Plus ist aktuell deaktiviert. Bitte versuche es später erneut.\n\nAuf unserem [Discord](https://sharezone.net/discord) halten wir dich auf dem Laufenden.",
          alignment: WrapAlignment.start,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
