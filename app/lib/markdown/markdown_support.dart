// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class MarkdownSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(color: Colors.grey, fontSize: 14, fontFamily: rubik);
    return MarkdownBody(
      data:
          "[Markdown](https://sharezone.net/markdown): \*\***fett**\\*\*, \**kursiv*\\*",
      styleSheet: MarkdownStyleSheet(p: style, a: linkStyle(context, 14)),
      selectable: true,
      onTapLink: (link, _, __) => launchURL(link),
    );
  }
}
