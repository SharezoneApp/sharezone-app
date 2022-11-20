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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';

import 'src/ui/ui.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({
    Key key,
    PrivacyPolicy privacyPolicy,
    PrivacyPolicyPageConfig config,
  })  : privacyPolicy = privacyPolicy ?? v2PrivacyPolicy,
        config = config ?? PrivacyPolicyPageConfig(),
        super(key: key);

  final PrivacyPolicy privacyPolicy;
  final PrivacyPolicyPageConfig config;

  @override
  Widget build(BuildContext context) {
    return Provider<PrivacyPolicyPageConfig>(
      create: (context) => config,
      child: ChangeNotifierProvider<PrivacyPolicyThemeSettings>(
          create: (context) {
            final themeSettings =
                Provider.of<ThemeSettings>(context, listen: false);
            return PrivacyPolicyThemeSettings(
              analytics: AnalyticsProvider.ofOrNullObject(context),
              themeSettings: Provider.of(context, listen: false),
              initialTextScalingFactor: themeSettings.textScalingFactor,
              initialVisualDensity: themeSettings.visualDensitySetting,
              initialThemeBrightness: themeSettings.themeBrightness,
              initialShowDebugThresholdIndicator:
                  config.showDebugThresholdIndicator,
            );
          },
          child: Provider(
            create: (context) {
              final itemScrollController = ItemScrollController();
              final itemPositionsListener = ItemPositionsListener.create();
              // TODO: Do we still need this class?
              return PrivacyPolicyTextDependencies(
                anchorsController: AnchorsController(
                  itemPositionsListener: itemPositionsListener,
                  itemScrollController: itemScrollController,
                ),
              );
            },
            child: Builder(
                builder: (context) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: context
                            .watch<PrivacyPolicyThemeSettings>()
                            .textScalingFactor),
                    child: ChangeNotifierProvider<TableOfContentsController>(
                      // TODO: Since CurrentlyReadController can now be
                      // instantiated independently it might make sense to
                      // initialize it when first building. Then lazy could be
                      // true again.
                      //
                      // Else the currently active section doesn't get tracked until
                      // the table of contents inside the bottom sheet was at least
                      // once manually opened (for layouts with a bottom sheet).
                      lazy: false,
                      create: (context) {
                        final dependencies =
                            Provider.of<PrivacyPolicyTextDependencies>(context,
                                listen: false);
                        final factory = PrivacyPolicyPageDependencyFactory(
                          anchorsController: dependencies.anchorsController,
                          privacyPolicy: privacyPolicy,
                          config: config,
                        );
                        return factory.tableOfContentsController;
                      },
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            visualDensity: context
                                .watch<PrivacyPolicyThemeSettings>()
                                .visualDensitySetting
                                .visualDensity,
                            floatingActionButtonTheme:
                                FloatingActionButtonThemeData(
                              backgroundColor: Theme.of(context).primaryColor,
                            )),
                        child: Scaffold(
                          body: Center(
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              final tocController =
                                  Provider.of<TableOfContentsController>(
                                      context,
                                      listen: false);

                              if (constraints.maxWidth > 1100) {
                                tocController.changeExpansionBehavior(
                                    ExpansionBehavior
                                        .leaveManuallyOpenedSectionsOpen);
                                return MainContentWide(
                                    privacyPolicy: privacyPolicy);
                              } else if (constraints.maxWidth > 500 &&
                                  constraints.maxHeight > 400) {
                                tocController.changeExpansionBehavior(
                                    ExpansionBehavior
                                        .alwaysAutomaticallyCloseSectionsAgain);
                                return MainContentNarrow(
                                    privacyPolicy: privacyPolicy);
                              } else {
                                tocController.changeExpansionBehavior(
                                    ExpansionBehavior
                                        .alwaysAutomaticallyCloseSectionsAgain);
                                return MainContentMobile(
                                    privacyPolicy: privacyPolicy);
                              }
                            }),
                          ),
                        ),
                      ),
                    ))),
          )),
    );
  }
}
