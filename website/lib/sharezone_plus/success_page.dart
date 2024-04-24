import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
              const Text(
                'Du hast Sharezone Plus erfolgreich für dein Kind erworben.\nVielen Dank für deine Unterstützung!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              MarkdownBody(
                data:
                    'Solltest du Fragen haben, kannst du dich jederzeit an unseren [Support](/support) wenden.',
                styleSheet: MarkdownStyleSheet(
                  textAlign: WrapAlignment.center,
                ),
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
