import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownCenteredText extends StatelessWidget {
  const MarkdownCenteredText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
        textAlign: WrapAlignment.center,
      ),
      onTapLink: (text, href, title) async {
        if (href == null) return;

        if (href == 'https://sharezone.net/privacy-policy') {
          Navigator.pushNamed(context, 'privacy-policy');
          return;
        }

        await launchUrl(Uri.parse(href));
      },
    );
  }
}
