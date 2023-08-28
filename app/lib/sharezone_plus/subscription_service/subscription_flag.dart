// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:key_value_store/key_value_store.dart';

class SubscriptionEnabledFlag extends ChangeNotifier {
  SubscriptionEnabledFlag(this.keyValueStore) {
    _isEnabled = keyValueStore.tryGetBool(cacheKey) ?? false;
  }
  final KeyValueStore keyValueStore;

  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;

  static const cacheKey = 'is_sharezone_plus_prototype_enabled';

  void toggle() {
    _isEnabled = !_isEnabled;
    keyValueStore.setBool(cacheKey, _isEnabled);
    notifyListeners();
  }
}
