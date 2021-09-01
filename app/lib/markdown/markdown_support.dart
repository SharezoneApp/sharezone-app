import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_widgets/theme.dart';

class MarkdownSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(color: Colors.grey, fontSize: 14, fontFamily: rubik);
    return MarkdownBody(
      data:
          "[Markdown](https://sharezone.net/markdown): \*\***fett**\\*\*, \**kursiv*\\*, Zeilenumbruch: \\",
      styleSheet: MarkdownStyleSheet(p: style, a: linkStyle(context, 14)),
      selectable: true,
      onTapLink: (link, _, __) => launchURL(link),
    );
  }
}
