// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_plus_page_ui/src/styled_markdown_text.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// A dialog that is shown when buying Sharezone Plus failed.
class BuyingFailedDialog extends StatelessWidget {
  const BuyingFailedDialog({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: Text(context.l10n.sharezonePlusBuyingFailedTitle),
        content: SingleChildScrollView(
          child: StyledMarkdownText(
            text: context.l10n.sharezonePlusBuyingFailedContent(error),
            alignment: WrapAlignment.start,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonActionsOk),
          ),
          FilledButton(
            onPressed: () async {
              const email = 'plus@sharezone.net';
              await launchUrl(Uri.parse('mailto:$email'));
            },
            child: Text(context.l10n.commonActionsContactSupport),
          ),
        ],
      ),
    );
  }
}
