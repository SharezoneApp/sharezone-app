// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class MarkdownSupport extends StatelessWidget {
  const MarkdownSupport({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.grey, fontSize: 14);
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(text: context.l10n.sharezoneWidgetsMarkdownSupportLabel),
          TextSpan(
            text: context.l10n.sharezoneWidgetsMarkdownSupportBold,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: context.l10n.sharezoneWidgetsMarkdownSupportSeparator),
          TextSpan(
            text: context.l10n.sharezoneWidgetsMarkdownSupportItalic,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
        style: style,
      ),
    );
  }
}
