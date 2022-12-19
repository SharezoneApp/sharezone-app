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
import 'package:sharezone/onboarding/sign_up/pages/privacy_policy/src/privacy_policy_src.dart';

import 'src/ui/ui.dart';

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({
    Key key,
    PrivacyPolicy privacyPolicy,
    PrivacyPolicyPageConfig config,
  })  : privacyPolicy = privacyPolicy ?? v2PrivacyPolicy,
        config = config ?? PrivacyPolicyPageConfig(),
        anchorsController = AnchorsController(),
        super(key: key);

  final PrivacyPolicy privacyPolicy;
  final PrivacyPolicyPageConfig config;
  final AnchorsController anchorsController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrivacyPolicy>(
        future: Future.delayed(Duration(seconds: 2), () => privacyPolicy),
        builder: (context, snapshot) {
          return Provider(
            create: (context) => PrivacyPolicyPageDependencyFactory(
              anchorsController: anchorsController,
              config: config,
              // Because the Provider will only lazily run `create` we will only
              // access the PrivacyPolicyPageDependencyFactory (which needs the
              // privacyPolicy) after the privacyPolicy has been sucessfully
              // loaded.
              // Otherwise this would lead to an error since `snapshot.data`
              // would equal `null`.
              privacyPolicy: snapshot.data,
            ),
            builder: (context, _) => MultiProvider(
                providers: [
                  Provider(create: (context) => anchorsController),
                  Provider<PrivacyPolicyPageConfig>(
                      create: (context) => config),
                  ChangeNotifierProvider<PrivacyPolicyThemeSettings>(
                    create: (context) {
                      final themeSettings =
                          Provider.of<ThemeSettings>(context, listen: false);
                      return _createPrivacyPolicyThemeSettings(
                          context, themeSettings, config);
                    },
                  ),
                  Provider<DocumentController>(
                      create: (context) =>
                          _factory(context).documentController),
                  ChangeNotifierProvider<TableOfContentsController>(
                    create: (context) =>
                        _factory(context).tableOfContentsController,
                  ),
                ],
                builder: (context, _) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: context
                            .watch<PrivacyPolicyThemeSettings>()
                            .textScalingFactor),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          visualDensity: context.ppVisualDensity,
                          floatingActionButtonTheme:
                              FloatingActionButtonThemeData(
                            backgroundColor: Theme.of(context).primaryColor,
                          )),
                      child: Scaffold(
                        body: Center(
                          child: LayoutBuilder(builder: (context, constraints) {
                            // If the privacy policy hasn't loaded yet we don't
                            //  use `Provider` to access a controller since this
                            //  would cause an error by running the
                            //  Provider.create function which requires a valid
                            //  privacy policy.
                            final tocControllerOrNull = snapshot.hasData
                                ? Provider.of<TableOfContentsController>(
                                    context,
                                    listen: false)
                                : null;

                            // TODO: Handle snapshot.error

                            // TODO: Test that layouts appear correctly on
                            // certain window sizes
                            if (constraints.maxWidth > 1100) {
                              tocControllerOrNull?.changeExpansionBehavior(
                                  ExpansionBehavior
                                      .leaveManuallyOpenedSectionsOpen);
                              return MainContentWide(
                                  privacyPolicy: snapshot.data);
                            } else if (constraints.maxWidth > 500 &&
                                constraints.maxHeight > 400) {
                              tocControllerOrNull?.changeExpansionBehavior(
                                  ExpansionBehavior
                                      .alwaysAutomaticallyCloseSectionsAgain);
                              return MainContentNarrow(
                                  privacyPolicy: snapshot.data);
                            } else {
                              tocControllerOrNull?.changeExpansionBehavior(
                                  ExpansionBehavior
                                      .alwaysAutomaticallyCloseSectionsAgain);
                              return MainContentMobile(
                                  privacyPolicy: snapshot.data);
                            }
                          }),
                        ),
                      ),
                    ))),
          );
        });
  }
}

PrivacyPolicyThemeSettings _createPrivacyPolicyThemeSettings(
  BuildContext context,
  ThemeSettings themeSettings,
  PrivacyPolicyPageConfig config,
) {
  return PrivacyPolicyThemeSettings(
    analytics: AnalyticsProvider.ofOrNullObject(context),
    themeSettings: Provider.of(context, listen: false),
    initialTextScalingFactor: themeSettings.textScalingFactor,
    initialVisualDensity: themeSettings.visualDensitySetting,
    initialThemeBrightness: themeSettings.themeBrightness,
    initialShowDebugThresholdIndicator: config.showDebugThresholdIndicator,
  );
}

PrivacyPolicyPageDependencyFactory _factory(BuildContext context) {
  final factory =
      Provider.of<PrivacyPolicyPageDependencyFactory>(context, listen: false);
  return factory;
}
