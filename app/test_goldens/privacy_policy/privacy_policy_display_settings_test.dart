// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/account/theme/theme_settings.dart';
import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';
import 'package:sharezone/privacy_policy/src/ui/common.dart';

void main() {
  group('showDisplaySettingsDialog', () {
    // Regression test for
    // https://github.com/SharezoneApp/sharezone-app/issues/785.
    testGoldens('displays as expected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<PrivacyPolicyThemeSettings>(
              create: (context) {
                final analytics = Analytics(NullAnalyticsBackend());
                return PrivacyPolicyThemeSettings(
                  analytics: analytics,
                  themeSettings: ThemeSettings(
                    analytics: analytics,
                    defaultTextScalingFactor: 1.0,
                    defaultThemeBrightness: ThemeBrightness.system,
                    defaultVisualDensity: VisualDensitySetting.standard(),
                    keyValueStore: InMemoryKeyValueStore(),
                  ),
                  config: PrivacyPolicyPageConfig(),
                );
              },
              builder: (context, _) => Center(
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () => showDisplaySettingsDialog(context),
                    child: Text("Open Dialog"),
                  );
                }),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'show_display_settings_dialog');
    });
  });
}
