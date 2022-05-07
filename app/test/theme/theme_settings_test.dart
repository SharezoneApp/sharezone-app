// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone/account/theme/theme_settings.dart';

import '../analytics/analytics_test.dart';

void main() {
  group('ThemeSettings', () {
    KeyValueStore keyValueStore;
    Analytics analytics;
    LocalAnalyticsBackend localAnalyticsBackend;

    setUp(() {
      keyValueStore = InMemoryKeyValueStore();
      localAnalyticsBackend = LocalAnalyticsBackend();
      analytics = Analytics(localAnalyticsBackend);
    });

    test('Uses default value if no value is already cached', () {
      final themeSettings = ThemeSettings(
        analytics: analytics,
        defaultTextScalingFactor: 1.2,
        defaultThemeBrightness: ThemeBrightness.dark,
        defaultVisualDensity: VisualDensity.comfortable,
        keyValueStore: keyValueStore,
      );

      expect(themeSettings.textScalingFactor, 1.2);
      expect(themeSettings.themeBrightness, ThemeBrightness.dark);
      expect(themeSettings.visualDensity, VisualDensity.comfortable);
    });

    test(
        'Uses cached values instead of default values if they are already cached',
        () {
      ThemeSettings themeSettings = ThemeSettings(
        analytics: analytics,
        defaultTextScalingFactor: 1.2,
        defaultThemeBrightness: ThemeBrightness.dark,
        defaultVisualDensity: VisualDensity.comfortable,
        keyValueStore: keyValueStore,
      );

      // Will write to cache internally
      themeSettings.textScalingFactor = 1.5;
      themeSettings.themeBrightness = ThemeBrightness.light;
      themeSettings.visualDensity = VisualDensity.compact;

      themeSettings = ThemeSettings(
        analytics: analytics,
        defaultTextScalingFactor: 1.2,
        defaultThemeBrightness: ThemeBrightness.dark,
        defaultVisualDensity: VisualDensity.comfortable,
        keyValueStore: keyValueStore,
      );

      expect(themeSettings.textScalingFactor, 1.5);
      expect(themeSettings.themeBrightness, ThemeBrightness.light);
      expect(themeSettings.visualDensity, VisualDensity.compact);
    });

    test('Tracks value changes via analytics', () {
      final themeSettings = ThemeSettings(
        analytics: analytics,
        defaultTextScalingFactor: 1.2,
        defaultThemeBrightness: ThemeBrightness.dark,
        defaultVisualDensity: VisualDensity.comfortable,
        keyValueStore: keyValueStore,
      );

      themeSettings.textScalingFactor = 2.0;
      expect(localAnalyticsBackend.loggedEvents[0], {
        'ui_text_scaling_factor_changed': {'text_scaling_factor': 2.0}
      });

      themeSettings.themeBrightness = ThemeBrightness.system;
      expect(localAnalyticsBackend.loggedEvents[1], {
        'ui_brightness_changed': {'brightness': 'system'}
      });

      themeSettings.visualDensity =
          VisualDensity(horizontal: 1.0, vertical: 1.5);
      expect(localAnalyticsBackend.loggedEvents[2], {
        'ui_visual_density_changed': {
          'visual_density': {'horizontal': 1.0, 'vertical': 1.5}
        }
      });
    });
  });
}
