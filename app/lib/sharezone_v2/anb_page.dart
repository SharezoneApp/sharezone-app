import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/privacy_policy/privacy_policy_page.dart';

import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';

class AnbPage extends StatelessWidget {
  static const tag = "anb-page";

  const AnbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyPage(privacyPolicy: anbPolicy);
  }
}

final anbPolicy = PrivacyPolicy(
  markdownText: anbMarkdown,
  tableOfContentSections: const IListConst([]),
  version: '1.0.0',
  downloadUrl: Uri.parse('https://sharezone.net/anb-v1-0-0-pdf'),
  lastChanged: DateTime(2024, 04, 22),
  // entersIntoForceOnOrNull: DateTime(2024, 04, 22),
);

const anbMarkdown = '''
# Allgemeine Nutzungsbedingungen

Bla Bla
''';
