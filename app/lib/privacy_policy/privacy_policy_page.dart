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
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';

import 'src/ui/ui.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const tag = "privacy-policy-page";

  PrivacyPolicyPage({
    Key? key,
    PrivacyPolicy? privacyPolicy,
    PrivacyPolicyPageConfig? config,
    this.showBackButton = true,
  })  : privacyPolicy = privacyPolicy ?? v1PrivacyPolicy,
        config = config ??
            PrivacyPolicyPageConfig(
              // When replacing the v1 privacy policy with the v2 this can be
              // deleted.
              //
              // For v1 we purposefully have to set a threshold higher up in the
              // page since the introdution section is so short that the second
              // section is already highlighted as currently read when opening
              // the page (since the second section title touches the
              // threshold).
              // With using this as the threshold the first section is
              // highlighted as currently read instead of the second section
              // when opening the page.
              threshold: const CurrentlyReadThreshold(0.08),
            ),
        anchorController = AnchorController(),
        super(key: key);

  final PrivacyPolicy privacyPolicy;
  final PrivacyPolicyPageConfig config;
  final AnchorController anchorController;
  final bool showBackButton;

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
                  textScaleFactor: context
                      .watch<PrivacyPolicyThemeSettings>()
                      .textScalingFactor),
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
                        );
                      } else if (constraints.maxWidth > 500 &&
                          constraints.maxHeight > 400) {
                        tocController.changeExpansionBehavior(ExpansionBehavior
                            .alwaysAutomaticallyCloseSectionsAgain);
                        return MainContentNarrow(
                          privacyPolicy: privacyPolicy,
                          showBackButton: showBackButton,
                        );
                      } else {
                        tocController.changeExpansionBehavior(ExpansionBehavior
                            .alwaysAutomaticallyCloseSectionsAgain);
                        return MainContentMobile(
                          privacyPolicy: privacyPolicy,
                          showBackButton: showBackButton,
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
