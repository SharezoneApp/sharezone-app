import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone_website/page.dart';
import 'package:sharezone_website/widgets/headline.dart';
import 'package:sharezone_website/widgets/section.dart';

import '../utils.dart';
import 'imprint.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  static const tag = 'imprint-page';

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
                      data: Imprint.offline().asMarkdown,
                      onTapLink: (link, href, title) => launchURL(link),
                      selectable: true,
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
