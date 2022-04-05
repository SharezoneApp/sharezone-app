// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';
import 'user_tip_key.dart';

class UserTipData {
  final Map<String, bool> _internalMap;

  const UserTipData._(this._internalMap);

  factory UserTipData.empty() {
    return UserTipData._({});
  }

  factory UserTipData.fromData(Map<String, dynamic> data) {
    return UserTipData._(decodeMap<bool>(data, (key, value) => value));
  }

  bool getValue(UserTipKey tipKey) {
    return _internalMap[tipKey.key] ?? tipKey.defaultValue;
  }

  UserTipData copyWith(UserTipKey tipKey, bool newValue) {
    final newMap = Map.of(_internalMap);
    newMap[tipKey.key] = newValue;
    return UserTipData._(newMap);
  }

  Map<String, bool> toJson() {
    return _internalMap;
  }
}
