// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import '../privacy_policy_src.dart';
import 'ui.dart';

class MainContentMobile extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const MainContentMobile({
    @required this.privacyPolicy,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = privacyPolicy == null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Datenschutzerklärung'),
        actions: [
          IconButton(
              onPressed: () {
                showDisplaySettingsDialog(context);
              },
              icon: Icon(Icons.display_settings)),
          IconButton(
            onPressed: isLoading ? null : () {},
            icon: Icon(Icons.download),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isLoading && privacyPolicy.hasNotYetEnteredIntoForce)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: PrivacyPolicySubheading(
                  entersIntoForceOn: privacyPolicy.entersIntoForceOnOrNull,
                ),
              ),
            Divider(height: 0, thickness: .5),
            Flexible(
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: PrivacyTextLoadingPlaceholder(),
                      )
                    : PrivacyPolicyText(privacyPolicy: privacyPolicy)),
            Divider(height: 0, thickness: .5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: OpenTocBottomSheetButton(enabled: !isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
