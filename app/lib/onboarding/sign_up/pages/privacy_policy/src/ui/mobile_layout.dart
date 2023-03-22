// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'ui.dart';

class MainContentMobile extends StatelessWidget {
  const MainContentMobile({
    @required this.privacyPolicyLoadingState,
    this.showBackButton = true,
    Key key,
  }) : super(key: key);

  final PrivacyPolicyLoadingState privacyPolicyLoadingState;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        title: Text('Datenschutzerklärung'),
        actions: [
          IconButton(
              onPressed: () {
                showDisplaySettingsDialog(context);
              },
              icon: Icon(Icons.display_settings)),
          // TODO: Doesn't seem to work on Android? (At lest on emulator).
          DownloadAsPDFButton.icon(
            enabled: privacyPolicyLoadingState.isSuccessful,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (privacyPolicyLoadingState
                    .privacyPolicyOrNull?.hasNotYetEnteredIntoForce ??
                false)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: PrivacyPolicySubheading(
                  entersIntoForceOn: privacyPolicyLoadingState
                      .privacyPolicyOrNull.entersIntoForceOnOrNull,
                ),
              ),
            Divider(height: 0, thickness: .5),
            Flexible(
              child: privacyPolicyLoadingState.when(
                onError: (e, s) =>
                    SizedBox.expand(child: LoadingFailureMainAreaContent()),
                onLoading: () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: PrivacyTextLoadingPlaceholder(),
                ),
                onSuccess: (privacyPolicy) =>
                    PrivacyPolicyText(privacyPolicy: privacyPolicy),
              ),
            ),
            Divider(height: 0, thickness: .5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              // TODO: Was `!privacyPolicyLoadingState.isSuccessful` instead of
              // `privacyPolicyLoadingState.isSuccessful` in mobile layout.
              // We should have a test for this behavior for every layout.
              child: OpenTocBottomSheetButton(
                  enabled: privacyPolicyLoadingState.isSuccessful),
            ),
          ],
        ),
      ),
    );
  }
}
