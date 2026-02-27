// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
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
        title: Text(context.l10n.adInfoDialogTitle),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: context.l10n.adInfoDialogBodyPrefix),
              TextSpan(
                text: context.l10n.websiteNavPlus,
                style: const TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).pop(true),
              ),
              TextSpan(text: context.l10n.adInfoDialogBodySuffix),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
            child: Text(context.l10n.commonActionsOk),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
