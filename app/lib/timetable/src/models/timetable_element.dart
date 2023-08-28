// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/timetable/src/models/timetable_element_properties.dart';
import 'package:time/time.dart';

class TimetableElement {
  final Date date;
  final GroupInfo? groupInfo;
  final Time start;
  final Time end;
  final dynamic data;
  final int priority;
  final TimetableElementProperties properties;

  const TimetableElement({
    required this.date,
    required this.start,
    required this.end,
    required this.groupInfo,
    this.data,
    this.priority = 0,
    this.properties = TimetableElementProperties.standard,
  });
}
