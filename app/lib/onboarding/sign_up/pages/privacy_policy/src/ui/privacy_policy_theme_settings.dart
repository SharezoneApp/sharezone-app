// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// @dart=2.14

// ignore: import_of_legacy_library_into_null_safe
import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/theme/theme_settings.dart';

/// Ephemeral theme settings that are scoped only to the privacy policy page.
///
/// Unlike [ThemeSettings] this class doesn't cache the settings.
/// Additionally all changes (except [themeBrightness]) are only applied to the 
/// privacy policy page.
/// If e.g. the the [PrivacyPolicyThemeSettings.textScalingFactor] is changed
/// [ThemeSettings.textScalingFactor] will stay the same.
class PrivacyPolicyThemeSettings extends ChangeNotifier {
  final Analytics _analytics;
  final ThemeSettings _themeSettings;
  final double textScalingFactorLowerBound;
  final double textScalingFactorUpperBound;

  PrivacyPolicyThemeSettings({
    required Analytics analytics,
    required ThemeSettings themeSettings,
    required double initialTextScalingFactor,
    required VisualDensitySetting initialVisualDensity,
    required ThemeBrightness initialThemeBrightness,
    this.textScalingFactorLowerBound = 0.1,
    this.textScalingFactorUpperBound = 5.0,
    bool initialShowDebugThresholdIndicator = false,
  })  : _analytics = analytics,
        _themeSettings = themeSettings {
    // TODO: Write tests for error
    if (initialTextScalingFactor.clamp(
            textScalingFactorLowerBound, textScalingFactorUpperBound) !=
        initialTextScalingFactor) {
      throw ArgumentError(
          'initialTextScalingFactor must be inside (inclusive) $textScalingFactorLowerBound - $textScalingFactorUpperBound');
    }
    _textScalingFactor = initialTextScalingFactor;
    _visualDensitySetting = initialVisualDensity;
    _themeBrightness = initialThemeBrightness;
    _showDebugThresholdIndicator = initialShowDebugThresholdIndicator;
  }

  // TODO: Write tests for clamping
  late double _textScalingFactor;
  double get textScalingFactor => _textScalingFactor;
  set textScalingFactor(double textScalingFactor) {
    textScalingFactor = textScalingFactor.clamp(
        textScalingFactorLowerBound, textScalingFactorUpperBound);
    _textScalingFactor = textScalingFactor;
    notifyListeners();

    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_privacy_policy_text_scaling_changed',
      data: {'text_scaling_factor': textScalingFactor},
    ));
  }

  late VisualDensitySetting _visualDensitySetting;
  VisualDensitySetting get visualDensitySetting => _visualDensitySetting;
  set visualDensitySetting(VisualDensitySetting value) {
    _visualDensitySetting = value;
    notifyListeners();

    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_privacy_policy_visual_density_changed',
      // TODO: Fix (here and other places)
      // Unhandled Exception: 'package:firebase_analytics/src/firebase_analytics.dart': Failed assertion: line 115 pos 9: 'value is String || value is num': 'string' OR 'number' must be set as the value of the parameter: visual_density
      data: {
        'visual_density': {
          'isAdaptivePlatformDensity': value.isAdaptivePlatformDensity,
          'horizontal': value.visualDensity.horizontal,
          'vertical': value.visualDensity.vertical
        }
      },
    ));
  }

  late ThemeBrightness _themeBrightness;
  ThemeBrightness get themeBrightness => _themeBrightness;
  set themeBrightness(ThemeBrightness value) {
    _themeBrightness = value;
    // Will log analytics event for us. Since we change it for the whole app
    // we don't need a specific analytics event only for the privacy policy page
    // like for other attributes above.
    _themeSettings.themeBrightness = value;
    notifyListeners();
  }

  late bool _showDebugThresholdIndicator;
  bool get showDebugThresholdIndicator => _showDebugThresholdIndicator;
  set showDebugThresholdIndicator(bool value) {
    _showDebugThresholdIndicator = value;
    notifyListeners();
  }
}
