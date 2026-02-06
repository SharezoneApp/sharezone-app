// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:legal/legal.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_utils/launch_link.dart';

class ImprintPage extends StatelessWidget {
  static const tag = 'imprint-page';

  const ImprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.imprintTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: MarkdownBody(
            data: markdownImprint,
            onTapLink: (text, href, _) => launchURL(href!),
            selectable: true,
          ),
        ),
      ),
      bottomNavigationBar: const ContactSupport(),
    );
  }
}
