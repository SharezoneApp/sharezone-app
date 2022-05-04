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

import 'theme_brightness.dart';

class ThemeSettingsNotifier extends ChangeNotifier {
  final KeyValueStore keyValueStore;

  ThemeSettingsNotifier({
    required this.keyValueStore,
    required double defaultTextScalingFactor,
    required VisualDensity defaultVisualDensity,
    required ThemeBrightness defaultThemeBrightness,
  }) {
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

    keyValueStore.setDouble(
        _currentTextScalingFactorCacheKey, textScalingFactor);
  }

  late VisualDensity _visualDensity;
  VisualDensity get visualDensity => _visualDensity;
  set visualDensity(VisualDensity value) {
    _visualDensity = value;
    notifyListeners();

    keyValueStore.setString(_currentVisualDensityCacheKey, value.serialize());
  }

  late ThemeBrightness _themeBrightness;
  ThemeBrightness get themeBrightness => _themeBrightness;
  set themeBrightness(ThemeBrightness value) {
    _themeBrightness = value;
    notifyListeners();

    keyValueStore.setString(_currentBrightnessCacheKey, value.serialize());
  }
}

extension on KeyValueStore {
  double? tryGetDouble(String key) {
    return _guard(() => getDouble(key));
  }

  String? tryGetString(String key) {
    return _guard(() => getString(key));
  }
}

T? _guard<T>(T Function() f) {
  try {
    return f();
  } catch (_) {
    return null;
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
