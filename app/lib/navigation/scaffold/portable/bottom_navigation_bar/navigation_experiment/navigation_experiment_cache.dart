// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';

import 'navigation_experiment_option.dart';

class NavigationExperimentCache extends BlocBase {
  static const key = 'navigation-experiment-option-key';

  final StreamingKeyValueStore _cache;

  final _currentNavigationSubject =
      BehaviorSubject<NavigationExperimentOption>();

  ValueStream<NavigationExperimentOption> get currentNavigation =>
      _currentNavigationSubject;

  NavigationExperimentCache(this._cache) {
    _cache
        .getString(key,
            defaultValue: NavigationExperimentOption.drawerAndBnb.name)
        .map(NavigationExperimentOption.values.byName)
        .listen(_currentNavigationSubject.sink.add);
  }

  void setNavigation(NavigationExperimentOption option) {
    _cache.setString(key, option.name);
  }

  @override
  void dispose() {
    _currentNavigationSubject.close();
  }
}
