// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:time/time.dart';

/// Dies sind die Parameter eines Elements im Stundenplan. Damit kann die PositionLogic eine
/// Zuordnung festmachen. Mithilfe der ID findet das TimetableElement dann die ausgerechnete
/// Position zur Darstellung.
class TimetableElementTimeProperties {
  final String id;
  final Date date;
  final Time start, end;

  const TimetableElementTimeProperties(
      this.id, this.date, this.start, this.end);
}
