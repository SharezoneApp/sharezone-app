// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:key_value_store/key_value_store.dart';

class BnbTutorialCache {
  final KeyValueStore _cache;

  static const _tutorialKey = 'bnb-tutorial-key';

  BnbTutorialCache(this._cache);

  bool wasTutorialCompleted() =>
      _cache.containsKey(_tutorialKey) && _cache.getBool(_tutorialKey) == true;

  void setTutorialAsCompleted() => _cache.setBool(_tutorialKey, true);
}
