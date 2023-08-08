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

class MainContentNarrow extends StatelessWidget {
  const MainContentNarrow({
    @required this.privacyPolicy,
    this.showBackButton = true,
    Key key,
  }) : super(key: key);

  final PrivacyPolicy privacyPolicy;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PrivacyPolicyHeading(),
                        if (privacyPolicy.hasNotYetEnteredIntoForce)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: PrivacyPolicySubheading(
                              entersIntoForceOn:
                                  privacyPolicy.entersIntoForceOnOrNull,
                            ),
                          ),
                        SizedBox(height: 3),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.spaceEvenly,
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 25,
                          runSpacing: 3,
                          children: const [
                            ChangeAppearanceButton(),
                            DownloadAsPDFButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (showBackButton)
                    BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              Divider(),
              Flexible(
                child: PrivacyPolicyText(privacyPolicy: privacyPolicy),
              ),
              // If height is not zero this would cause a an uneven vertical
              // padding for the button below.
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: OpenTocBottomSheetButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
