// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// @dart=2.14

import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:key_value_store/key_value_store.dart';

/// [ThemeBrightness] adds a "system" value that is missing in the Flutter
/// [Brightness] enum.
///
/// This lets one choose to inherit the system brightness.
enum ThemeBrightness {
  /// The color is dark and will require a light text color to achieve readable
  /// contrast.
  ///
  /// For example, the color might be dark grey, requiring white text.
  dark,

  /// The color is light and will require a dark text color to achieve readable
  /// contrast.
  ///
  /// For example, the color might be bright white, requiring black text.
  light,

  /// Automatically use either dark or light brightness depending on the setting
  /// of the system running this app.
  ///
  /// If e.g. the MacBook of the user uses dark mode then we will also use dark
  /// mode.
  system,
}

/// Used to change theme settings dynamically inside the app.
///
/// The changed settings will be automatically persisted.
///
/// For example one can use this class to change from dark mode to light mode
/// when the user toggles the corresponding setting.
///
/// This [ThemeSettings] should be provided via [Provider].
/// Inside the UI [ThemeSettings] can then be used like this:
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   // Will automatically rebuild if properties of [ThemeSettings] change.
///   // See also `context.select` to only rebuild if the brightness changes.
///   final themeSettings = context.watch<ThemeSettings>();
///
///   return Column(
///     children: [
///       Text('Current brightness: ${themeSettings.themeBrightness}'),
///       ElevatedButton(
///         child: Text('Change to dark-mode'),
///         onPressed: () => themeSettings.themeBrightness = ThemeBrightness.dark,
///       )
///     ],
///   );
/// }
/// ```
class ThemeSettings extends ChangeNotifier {
  final KeyValueStore _keyValueStore;
  final Analytics _analytics;

  static const String currentTextScalingFactorCacheKey =
      'currentTextScalingFactorCacheKey';
  static const String currentVisualDensityCacheKey =
      'currentVisualDensityCacheKey';
  static const currentBrightnessCacheKey = 'currentBrightnessCacheKey';

  ThemeSettings({
    required KeyValueStore keyValueStore,
    required Analytics analytics,

    /// The value assigned to [textScalingFactor] if no other value is cached.
    required double defaultTextScalingFactor,

    /// The value assigned to [visualDensity] if no other value is cached.
    required VisualDensitySetting defaultVisualDensity,

    /// The value assigned to [themeBrightness] if no other value is cached.
    required ThemeBrightness defaultThemeBrightness,
  })  : _keyValueStore = keyValueStore,
        _analytics = analytics {
    _textScalingFactor =
        keyValueStore.tryGetDouble(currentTextScalingFactorCacheKey) ??
            defaultTextScalingFactor;

    _visualDensitySetting = keyValueStore
            .tryGetString(currentVisualDensityCacheKey)
            .toVisualDensity() ??
        defaultVisualDensity;

    _themeBrightness = keyValueStore
            .tryGetString(currentBrightnessCacheKey)
            .toThemeBrightness() ??
        defaultThemeBrightness;
  }

  late double _textScalingFactor;
  double get textScalingFactor => _textScalingFactor;
  set textScalingFactor(double textScalingFactor) {
    _textScalingFactor = textScalingFactor;
    notifyListeners();

    _keyValueStore.setDouble(
        currentTextScalingFactorCacheKey, textScalingFactor);
    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_text_scaling_factor_changed',
      data: {'text_scaling_factor': textScalingFactor},
    ));
  }

  late VisualDensitySetting _visualDensitySetting;
  VisualDensitySetting get visualDensitySetting => _visualDensitySetting;
  set visualDensitySetting(VisualDensitySetting value) {
    _visualDensitySetting = value;
    notifyListeners();

    _keyValueStore.setString(currentVisualDensityCacheKey, value.serialize());
    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_visual_density_changed',
      data: {
        // bool is not allowed in firebase_analytics so we use `toString`.
        'isAdaptivePlatformDensity': value.isAdaptivePlatformDensity.toString(),
        'horizontal': value.visualDensity.horizontal,
        'vertical': value.visualDensity.vertical
      },
    ));
  }

  late ThemeBrightness _themeBrightness;
  ThemeBrightness get themeBrightness => _themeBrightness;
  set themeBrightness(ThemeBrightness value) {
    _themeBrightness = value;
    notifyListeners();

    _keyValueStore.setString(currentBrightnessCacheKey, value.serialize());
    _analytics.log(NamedAnalyticsEvent(
      name: 'ui_brightness_changed',
      data: {'brightness': value.serialize()},
    ));
  }
}

extension on VisualDensitySetting {
  String serialize() {
    return jsonEncode({
      'isAdaptivePlatformDensity': isAdaptivePlatformDensity,
      'horizontal': visualDensity.horizontal,
      'vertical': visualDensity.vertical,
    });
  }
}

extension on String? {
  VisualDensitySetting? toVisualDensity() {
    if (this == null) return null;
    final map = jsonDecode(this!) as Map;

    if (map['isAdaptivePlatformDensity'] != null &&
        map['isAdaptivePlatformDensity'] == true) {
      // We return [VisualDensitySetting.adaptivePlatformDensity] (which calls
      // [VisualDensity.adaptivePlatformDensity]) instead of using the cached
      // values because theoretically Flutter might change the default values of
      // [VisualDensity.adaptivePlatformDensity] in the future.
      return VisualDensitySetting.adaptivePlatformDensity();
    }

    return VisualDensitySetting.manual(
      VisualDensity(
        horizontal: map['horizontal'] as double,
        vertical: map['vertical'] as double,
      ),
    );
  }
}

/// The current [VisualDensity].
///
/// This extra class is necessary to differentiate if a user has chosen
/// [VisualDensity.adaptivePlatformDensity] or a manual setting which happens to
/// be the same value as [VisualDensity.adaptivePlatformDensity] (one can't
/// tell by just looking at [VisualDensity]).
///
/// This allows the user choose between different [VisualDensity] values and the
/// adaptive platform density.
///
/// For example: On desktop the default density is [VisualDensity.compact], i.e.
/// [VisualDensity.adaptivePlatformDensity] will return [VisualDensity.compact].
/// Without this class we couldn't easily know if the user just uses the value
/// returned by [VisualDensity.adaptivePlatformDensity] or if
/// [VisualDensity.compact] was chosen manually.
/// This would mean that we couldn't easily highlight the current setting in the
/// UI (since it could either be "default"
/// [VisualDensity.adaptivePlatformDensity] or "compact"
/// [VisualDensity.compact].)
class VisualDensitySetting {
  final VisualDensity visualDensity;
  final bool isAdaptivePlatformDensity;

  /// Corresponds to [VisualDensity.adaptivePlatformDensity].
  ///
  /// This will automatically use the platform's default density by setting
  /// [visualDensity] to [VisualDensity.adaptivePlatformDensity].
  /// [isAdaptivePlatformDensity] will be true.
  VisualDensitySetting.adaptivePlatformDensity()
      : visualDensity = VisualDensity.adaptivePlatformDensity,
        isAdaptivePlatformDensity = true;

  /// Corresponds to [VisualDensity.standard].
  ///
  /// [isAdaptivePlatformDensity] will be false.
  VisualDensitySetting.standard()
      : visualDensity = VisualDensity.standard,
        isAdaptivePlatformDensity = false;

  /// Corresponds to [VisualDensity.compact].
  ///
  /// [isAdaptivePlatformDensity] will be false.
  VisualDensitySetting.compact()
      : visualDensity = VisualDensity.compact,
        isAdaptivePlatformDensity = false;

  /// Corresponds to [VisualDensity.comfortable].
  ///
  /// [isAdaptivePlatformDensity] will be false.
  VisualDensitySetting.comfortable()
      : visualDensity = VisualDensity.comfortable,
        isAdaptivePlatformDensity = false;

  /// Use a custom [VisualDensity].
  ///
  /// [isAdaptivePlatformDensity] will be false.
  VisualDensitySetting.manual(this.visualDensity)
      : isAdaptivePlatformDensity = false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VisualDensitySetting &&
        other.visualDensity == visualDensity &&
        other.isAdaptivePlatformDensity == isAdaptivePlatformDensity;
  }

  @override
  int get hashCode {
    return Object.hash(visualDensity, isAdaptivePlatformDensity);
  }

  @override
  String toString() {
    return 'VisualDensitySetting(visualDensity: $visualDensity, isAdaptivePlatformDensity: $isAdaptivePlatformDensity)';
  }
}

extension on ThemeBrightness {
  String serialize() {
    return {
      ThemeBrightness.dark: 'dark',
      ThemeBrightness.light: 'light',
      ThemeBrightness.system: 'system',
    }[this]!;
  }
}

extension on String? {
  ThemeBrightness? toThemeBrightness() {
    if (this == null) return null;

    return {
      'dark': ThemeBrightness.dark,
      'light': ThemeBrightness.light,
      'system': ThemeBrightness.system,
    }[this];
  }
}
