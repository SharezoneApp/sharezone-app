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

// TODO: Add tests and docs
class PrivacyPolicyThemeSettings extends ChangeNotifier {
  final Analytics _analytics;
  final ThemeSettings _themeSettings;

  PrivacyPolicyThemeSettings({
    required Analytics analytics,
    required ThemeSettings themeSettings,

    /// The value assigned to [textScalingFactor] if no other value is cached.
    required double initialTextScalingFactor,

    /// The value assigned to [visualDensity] if no other value is cached.
    required VisualDensity initialVisualDensity,

    /// The value assigned to [themeBrightness] if no other value is cached.
    required ThemeBrightness initialThemeBrightness,
  })  : _analytics = analytics,
        _themeSettings = themeSettings {
    _textScalingFactor = initialTextScalingFactor;
    _visualDensity = initialVisualDensity;
    _themeBrightness = initialThemeBrightness;
  }

  late double _textScalingFactor;
  double get textScalingFactor => _textScalingFactor;
  set textScalingFactor(double textScalingFactor) {
    _textScalingFactor = textScalingFactor;
    notifyListeners();

    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_privacy_policy_text_scaling_factor_changed',
      data: {'text_scaling_factor': textScalingFactor},
    ));
  }

  late VisualDensity _visualDensity;
  VisualDensity get visualDensity => _visualDensity;
  set visualDensity(VisualDensity value) {
    _visualDensity = value;
    notifyListeners();

    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_privacy_policy_visual_density_changed',
      data: {
        'visual_density': {
          'horizontal': value.horizontal,
          'vertical': value.vertical
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
}
