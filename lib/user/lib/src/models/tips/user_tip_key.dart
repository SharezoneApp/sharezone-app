// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';

class UserTipKey {
  final bool defaultValue;
  final String key;
  const UserTipKey({
    @required this.defaultValue,
    @required this.key,
  });
}
