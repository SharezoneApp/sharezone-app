// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:meta/meta.dart';

import 'abgaben_commands.dart';
import 'dateiname.dart';

class DateiHinzufuegenCommand extends AbgabeCommand {
  final AbgabedateiId dateiId;
  final Dateiname dateiname;

  DateiHinzufuegenCommand({
    @required AbgabeId abgabeId,
    @required this.dateiId,
    @required this.dateiname,
  }) : super.randomId(abgabeId) {
    ArgumentError.checkNotNull(dateiId, 'dateiId');
    ArgumentError.checkNotNull(dateiname, 'dateiname');
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is DateiHinzufuegenCommand &&
            other.dateiId == dateiId &&
            other.dateiname == dateiname;
  }

  @override
  int get hashCode => dateiId.hashCode ^ dateiname.hashCode;

  @override
  String toString() {
    return '$runtimeType(abgabeId:$abgabeId, dateiId: $dateiId, dateiname: $dateiname)';
  }
}
