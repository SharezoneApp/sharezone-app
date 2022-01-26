// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:shared_preferences/shared_preferences.dart';

bool exitsInCacheAndIsTrueOrFalse(
    SharedPreferences pref, String key, bool value) {
  return pref.getKeys().contains(key) && pref.getBool(key) == value;
}