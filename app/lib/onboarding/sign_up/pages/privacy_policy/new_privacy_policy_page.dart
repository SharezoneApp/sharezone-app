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

import 'src/privacy_policy_v2.dart';
import 'src/widgets/privacy_policy_widgets.dart';

class PrivacyPolicyPageConfig {
  final CurrentlyReadThreshold threshold;

  /// Show a marker at [CurrentlyReadThreshold.position].
  final bool showDebugThresholdMarker;
  final PrivacyPolicyEndSection endSection;

  factory PrivacyPolicyPageConfig({
    CurrentlyReadThreshold threshold,
    bool showDebugThresholdMarker,
    PrivacyPolicyEndSection endSection,
  }) {
    return PrivacyPolicyPageConfig._(
      threshold ?? CurrentlyReadThreshold(0.1),
      showDebugThresholdMarker ?? false,
      endSection ?? PrivacyPolicyEndSection.metadata(),
    );
  }
  PrivacyPolicyPageConfig._(
    this.threshold,
    this.showDebugThresholdMarker,
    this.endSection,
  );
}

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
            );
          },
          child: Provider(
            create: (context) {
              final itemScrollController = ItemScrollController();
              final itemPositionsListener = ItemPositionsListener.create();
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
                      // Else the currently active section doesn't get tracked until
                      // the table of contents inside the bottom sheet was at least
                      // once manually opened (for layouts with a bottom sheet).
                      lazy: false,
                      create: (context) {
                        final dependencies =
                            Provider.of<PrivacyPolicyTextDependencies>(context,
                                listen: false);
                        return TableOfContentsController(
                            documentSectionController:
                                DocumentSectionController(
                              dependencies.anchorsController,
                              threshold: config.threshold,
                            ),
                            tocDocumentSections:
                                privacyPolicy.tableOfContentSections,
                            threshold: config.threshold,
                            // We change it when building the different layouts
                            // anyway so it doesn't really matter what value we use
                            // here.
                            initialExpansionBehavior: ExpansionBehavior
                                .alwaysAutomaticallyCloseSectionsAgain,
                            endSection: config.endSection);
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
