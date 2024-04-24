// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class StyledMarkdownText extends StatelessWidget {
  const StyledMarkdownText({
    super.key,
    required this.text,
    this.alignment = WrapAlignment.center,
    this.onPressedTermsOfService,
    this.onPressedPrivacyPolicy,
  });

  final String text;
  final WrapAlignment alignment;
  final VoidCallback? onPressedTermsOfService;
  final VoidCallback? onPressedPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
        textAlign: alignment,
      ),
      onTapLink: (text, href, title) async {
        if (href == null) return;

        if (href == 'https://sharezone.net/terms-of-service' &&
            onPressedTermsOfService != null) {
          onPressedTermsOfService!();
          return;
        }

        if (href == 'https://sharezone.net/privacy-policy' &&
            onPressedPrivacyPolicy != null) {
          onPressedPrivacyPolicy!();
          return;
        }

        await launchUrl(Uri.parse(href));
      },
    );
  }
}
