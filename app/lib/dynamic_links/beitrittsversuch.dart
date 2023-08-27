// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:common_domain_models/common_domain_models.dart';

class Beitrittsversuch {
  final Sharecode sharecode;

  Beitrittsversuch({required this.sharecode});

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is Beitrittsversuch && sharecode == other.sharecode;
  }

  @override
  int get hashCode => sharecode.hashCode;

  @override
  String toString() {
    return "Beitrittsversuch(publicKey: $sharecode)";
  }
}
