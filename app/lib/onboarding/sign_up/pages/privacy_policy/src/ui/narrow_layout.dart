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

class MainContentNarrow extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;

  const MainContentNarrow({
    @required this.privacyPolicy,
    Key key,
  }) : super(key: key);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // TODO: Fix - This is not centered with the stuff below it.
                  Expanded(
                    child: Center(
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
                        ],
                      ),
                    ),
                  ),
                ],
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
              Divider(),
              Flexible(child: PrivacyPolicyText(privacyPolicy: privacyPolicy)),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Inhaltsverzeichnis'),
                      Icon(Icons.expand_less),
                    ],
                  ),
                  onPressed: () {
                    showTableOfContentsBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
