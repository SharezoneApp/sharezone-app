// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';

/// [MeetingId] sollte nicht von [Id] erben, weil im Constructor [Id] überprüft
/// wird, ob die [Id] null oder leer ist. Da das Backend einige Sekunden zur
/// Erstellung der [MeetingId] benötigt wird, ist die Meeting am Anfang immer
/// leer or null. Alternativ könnte im [MeetingBloc] auch die [MeetingId] mit
/// [Optional] genutzt werden.
class MeetingId {
  final String id;

  MeetingId(this.id);

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
