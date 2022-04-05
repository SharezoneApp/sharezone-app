// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';

import 'auto_id_generator.dart';

class AbgabeEventId extends Id {
  AbgabeEventId(String id) : super(id, 'AbgabeEventId');
}

abstract class AbgabeCommand {
  final AbgabeEventId id;
  final AbgabeId abgabeId;
  UserId get abgeberId => abgabeId.nutzerId;

  AbgabeCommand(
    this.id,
    this.abgabeId,
  ) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(abgabeId, 'abgabeId');
  }

  AbgabeCommand.randomId(this.abgabeId)
      : id = AbgabeEventId(AutoIdGenerator.autoId());

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is AbgabeCommand && other.id == id && other.abgabeId == abgabeId;
  }

  @override
  int get hashCode => id.hashCode ^ abgabeId.hashCode;

  @override
  String toString() {
    return 'AbgabeCommand(id: $id, abgabeId: $abgabeId)';
  }
}
