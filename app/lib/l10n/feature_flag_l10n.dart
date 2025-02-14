// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

class FeatureFlagl10n extends ChangeNotifier {
  FeatureFlagl10n(this.keyValueStore) {
    _subscription = keyValueStore
        .getBool('l10n_enabled', defaultValue: false)
        .listen((event) {
          final newValue = event == true;
          if (isl10nEnabled != newValue) {
            isl10nEnabled = newValue;
            notifyListeners();
          }
        });
  }

  final StreamingKeyValueStore keyValueStore;
  late StreamSubscription<bool> _subscription;
  bool isl10nEnabled = false;

  void toggle() {
    isl10nEnabled = !isl10nEnabled;
    keyValueStore.setBool('l10n_enabled', isl10nEnabled);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
