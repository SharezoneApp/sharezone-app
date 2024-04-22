// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/legal/privacy_policy/src/privacy_policy_src.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/ui/ui.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const tag = "privacy-policy-page";

  PrivacyPolicyPage({
    super.key,
    PrivacyPolicy? privacyPolicy,
    PrivacyPolicyPageConfig? config,
    this.showBackButton = true,
    this.headingText = 'Datenschutzerklärung',
  })  : privacyPolicy = privacyPolicy ?? v2PrivacyPolicy,
        config = config ?? PrivacyPolicyPageConfig(),
        anchorController = AnchorController();

  final PrivacyPolicy privacyPolicy;
  final PrivacyPolicyPageConfig config;
  final AnchorController anchorController;
  final bool showBackButton;
  final String headingText;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PrivacyPolicyPageDependencyFactory(
        anchorController: anchorController,
        config: config,
        privacyPolicy: privacyPolicy,
      ),
      builder: (context, _) => MultiProvider(
          providers: [
            Provider(create: (context) => anchorController),
            Provider<PrivacyPolicyPageConfig>(create: (context) => config),
            ChangeNotifierProvider<PrivacyPolicyThemeSettings>(
              create: (context) {
                final themeSettings =
                    Provider.of<ThemeSettings>(context, listen: false);
                return _createPrivacyPolicyThemeSettings(
                    context, themeSettings, config);
              },
            ),
            Provider<DocumentController>(
                create: (context) => _factory(context).documentController),
            ChangeNotifierProvider<TableOfContentsController>(
              create: (context) => _factory(context).tableOfContentsController,
            ),
            Provider<Uri>(create: (context) => privacyPolicy.downloadUrl),
          ],
          builder: (context, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(context
                      .watch<PrivacyPolicyThemeSettings>()
                      .textScalingFactor)),
              child: Theme(
                data: Theme.of(context).copyWith(
                    visualDensity: context.ppVisualDensity,
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Theme.of(context).primaryColor,
                    )),
                child: Scaffold(
                  body: Center(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final tocController =
                          Provider.of<TableOfContentsController>(context,
                              listen: false);

                      if (constraints.maxWidth > 1100) {
                        tocController.changeExpansionBehavior(
                            ExpansionBehavior.leaveManuallyOpenedSectionsOpen);
                        return MainContentWide(
                          privacyPolicy: privacyPolicy,
                          showBackButton: showBackButton,
                          headingText: headingText,
                        );
                      } else if (constraints.maxWidth > 500 &&
                          constraints.maxHeight > 400) {
                        tocController.changeExpansionBehavior(ExpansionBehavior
                            .alwaysAutomaticallyCloseSectionsAgain);
                        return MainContentNarrow(
                          privacyPolicy: privacyPolicy,
                          showBackButton: showBackButton,
                          headingText: headingText,
                        );
                      } else {
                        tocController.changeExpansionBehavior(ExpansionBehavior
                            .alwaysAutomaticallyCloseSectionsAgain);
                        return MainContentMobile(
                          privacyPolicy: privacyPolicy,
                          showBackButton: showBackButton,
                          headingText: headingText,
                        );
                      }
                    }),
                  ),
                ),
              ))),
    );
  }
}

PrivacyPolicyThemeSettings _createPrivacyPolicyThemeSettings(
  BuildContext context,
  ThemeSettings themeSettings,
  PrivacyPolicyPageConfig config,
) {
  return PrivacyPolicyThemeSettings(
    themeSettings: themeSettings,
    config: config,
    // Analytics might not always be provided when the privacy policy page needs
    // to be shown, for example when looking at the privacy policy in the
    // registration process.
    // `AnalyticsProvider.ofOrNullObject(context)` will return a
    // "null object" in this case which will just do nothing when used.
    analytics: AnalyticsProvider.ofOrNullObject(context),
  );
}

PrivacyPolicyPageDependencyFactory _factory(BuildContext context) {
  final factory =
      Provider.of<PrivacyPolicyPageDependencyFactory>(context, listen: false);
  return factory;
}
