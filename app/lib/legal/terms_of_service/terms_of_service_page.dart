// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/legal/privacy_policy/privacy_policy_page.dart';
import 'package:sharezone/legal/privacy_policy/src/privacy_policy_src.dart';

class TermsOfServicePage extends StatelessWidget {
  static const tag = "terms-of-service-page";

  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyPolicyPage(privacyPolicy: anbPolicy);
  }
}

final anbPolicy = PrivacyPolicy(
  markdownText: tocMarkdown,
  tableOfContentSections:
      IListConst([DocumentSection(const DocumentSectionId('abc'), 'Abc')]),
  version: '1.0.0',
  downloadUrl: Uri.parse('https://sharezone.net/anb-v1-0-0-pdf'),
  lastChanged: DateTime(2024, 04, 22),
);

const tocMarkdown = '''
# Allgemeine Nutzungsbedingungen

## Abc

Bla Bla
''';
