// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';

PrivacyPolicy privacyPolicyWith({
  List<DocumentSection> tableOfContentSections,
  String markdown,
}) {
  return PrivacyPolicy(
    lastChanged: DateTime(2022, 03, 04),
    tableOfContentSections: tableOfContentSections.toIList() ??
        v2PrivacyPolicy.tableOfContentSections,
    version: '2.0.0',
    downloadUrl: Uri.parse('https://sharezone.net/dse-v2-0-0-pdf'),
    markdownText: markdown ?? v2PrivacyPolicy.markdownText,
    entersIntoForceOnOrNull: null,
  );
}
