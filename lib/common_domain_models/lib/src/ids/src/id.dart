// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:util/util.dart';

class Id {
  final String id;

  Id(this.id, [String idName]) {
    throwIfNullOrEmpty(id, idName ?? 'id');
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || other is Id && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return id;
  }
}
