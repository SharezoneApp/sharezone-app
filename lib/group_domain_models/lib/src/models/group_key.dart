// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'group_type.dart';

class GroupKey {
  final String id;
  final GroupType groupType;

  const GroupKey({
    required this.id,
    required this.groupType,
  });

  @override
  operator ==(other) {
    return other is GroupKey && id == other.id && groupType == other.groupType;
  }

  @override
  int get hashCode {
    return Object.hashAll([id, groupType]);
  }
}
