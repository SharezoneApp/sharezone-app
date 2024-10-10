// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:legal/legal.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/section.dart';

import '../utils.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  static const tag = 'imprint';

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      children: [
        Align(
          child: Section(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    child: Headline(
                      "Impressum",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: ThemeData.light(),
                    child: MarkdownBody(
                      data: markdownImprint,
                      onTapLink: (link, href, title) => launchUrl(href!),
                      selectable: true,
                      softLineBreak: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
