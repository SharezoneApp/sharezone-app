// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// @dart=2.14

import 'dart:convert';

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

  ThemeSettings({
    required KeyValueStore keyValueStore,

    /// The value assigned to [textScalingFactor] if no other value is cached.
    required double defaultTextScalingFactor,

    /// The value assigned to [visualDensity] if no other value is cached.
    required VisualDensity defaultVisualDensity,

    /// The value assigned to [themeBrightness] if no other value is cached.
    required ThemeBrightness defaultThemeBrightness,
  }) : _keyValueStore = keyValueStore {
    _textScalingFactor =
        keyValueStore.tryGetDouble(_currentTextScalingFactorCacheKey) ??
            defaultTextScalingFactor;

    _visualDensity = keyValueStore
            .tryGetString(_currentVisualDensityCacheKey)
            .toVisualDensity() ??
        defaultVisualDensity;

    _themeBrightness = keyValueStore
            .tryGetString(_currentBrightnessCacheKey)
            .toThemeBrightness() ??
        defaultThemeBrightness;
  }

  late double _textScalingFactor;
  double get textScalingFactor => _textScalingFactor;
  set textScalingFactor(double textScalingFactor) {
    _textScalingFactor = textScalingFactor;
    notifyListeners();

    _keyValueStore.setDouble(
        _currentTextScalingFactorCacheKey, textScalingFactor);
  }

  late VisualDensity _visualDensity;
  VisualDensity get visualDensity => _visualDensity;
  set visualDensity(VisualDensity value) {
    _visualDensity = value;
    notifyListeners();

    _keyValueStore.setString(_currentVisualDensityCacheKey, value.serialize());
  }

  late ThemeBrightness _themeBrightness;
  ThemeBrightness get themeBrightness => _themeBrightness;
  set themeBrightness(ThemeBrightness value) {
    _themeBrightness = value;
    notifyListeners();

    _keyValueStore.setString(_currentBrightnessCacheKey, value.serialize());
  }
}

const String _currentTextScalingFactorCacheKey =
    'currentTextScalingFactorCacheKey';
const String _currentVisualDensityCacheKey = 'currentVisualDensityCacheKey';

extension on VisualDensity {
  String serialize() {
    return jsonEncode({
      'horizontal': horizontal,
      'vertical': vertical,
    });
  }
}

extension on String? {
  VisualDensity? toVisualDensity() {
    if (this == null) return null;
    final _map = jsonDecode(this!) as Map;

    return VisualDensity(
      horizontal: _map['horizontal'] as double,
      vertical: _map['vertical'] as double,
    );
  }
}

const _currentBrightnessCacheKey = 'currentBrightnessCacheKey';

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
