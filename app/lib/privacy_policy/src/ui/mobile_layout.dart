// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';

import 'ui.dart';

class MainContentMobile extends StatelessWidget {
  const MainContentMobile({
    required this.privacyPolicy,
    this.showBackButton = true,
    super.key,
  });

  final PrivacyPolicy privacyPolicy;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        title: const Text('Datenschutzerklärung'),
        actions: [
          IconButton(
              onPressed: () {
                showDisplaySettingsDialog(context);
              },
              icon: const Icon(Icons.display_settings)),
          const SizedBox(width: 5),
          const DownloadAsPDFButton.icon(),
          const SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (privacyPolicy.hasNotYetEnteredIntoForce)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: PrivacyPolicySubheading(
                  entersIntoForceOn: privacyPolicy.entersIntoForceOnOrNull,
                ),
              ),
            const Divider(height: 0, thickness: .5),
            Flexible(
              child: PrivacyPolicyText(privacyPolicy: privacyPolicy),
            ),
            const Divider(height: 0, thickness: .5),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: OpenTocBottomSheetButton(),
            ),
          ],
        ),
      ),
    );
  }
}
