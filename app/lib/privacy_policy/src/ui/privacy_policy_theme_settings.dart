// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/theme/theme_settings.dart';

import '../privacy_policy_src.dart';

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
    @required Analytics analytics,
    @required ThemeSettings themeSettings,
    @required PrivacyPolicyPageConfig config,
    this.textScalingFactorLowerBound = 0.1,
    this.textScalingFactorUpperBound = 5.0,
  })  : _analytics = analytics,
        _themeSettings = themeSettings {
    _textScalingFactor = themeSettings.textScalingFactor;
    _visualDensitySetting = themeSettings.visualDensitySetting;
    _themeBrightness = themeSettings.themeBrightness;
    _showDebugThresholdIndicator = config.showDebugThresholdIndicator;
  }

  double _textScalingFactor;
  double get textScalingFactor => _textScalingFactor;
  set textScalingFactor(double textScalingFactor) {
    textScalingFactor = textScalingFactor
        .clamp(textScalingFactorLowerBound, textScalingFactorUpperBound)
        .toDouble();
    _textScalingFactor = textScalingFactor;
    notifyListeners();

    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_privacy_policy_text_scaling_changed',
      data: {'text_scaling_factor': textScalingFactor},
    ));
  }

  VisualDensitySetting _visualDensitySetting;
  VisualDensitySetting get visualDensitySetting => _visualDensitySetting;
  set visualDensitySetting(VisualDensitySetting value) {
    _visualDensitySetting = value;
    notifyListeners();

    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_privacy_policy_visual_density_changed',
      data: {
        'isAdaptivePlatformDensity': value.isAdaptivePlatformDensity,
        'horizontal': value.visualDensity.horizontal,
        'vertical': value.visualDensity.vertical,
      },
    ));
  }

  ThemeBrightness _themeBrightness;
  ThemeBrightness get themeBrightness => _themeBrightness;
  set themeBrightness(ThemeBrightness value) {
    _themeBrightness = value;
    // Will log analytics event for us. Since we change it for the whole app
    // we don't need a specific analytics event only for the privacy policy page
    // like for other attributes above.
    _themeSettings.themeBrightness = value;
    notifyListeners();
  }

  bool _showDebugThresholdIndicator;
  bool get showDebugThresholdIndicator => _showDebugThresholdIndicator;
  set showDebugThresholdIndicator(bool value) {
    _showDebugThresholdIndicator = value;
    notifyListeners();
  }
}
