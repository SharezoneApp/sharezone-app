// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/support_page.dart';

class PlusSuccessPage extends StatelessWidget {
  const PlusSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 75),
              const SizedBox(height: 12),
              Text(
                context.l10n.websiteSharezonePlusSuccessMessage,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              MarkdownBody(
                data: context.l10n.websiteSharezonePlusSuccessSupport,
                styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center),
                onTapLink: (text, href, title) {
                  Navigator.pushNamed(context, SupportPage.tag);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
