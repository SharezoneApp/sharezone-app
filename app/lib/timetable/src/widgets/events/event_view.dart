// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';

class EventView {
  final String? courseName;
  final String groupID, dateText, title;
  final Design? design;

  // Wird nur für die Weitergabe an die Event-Edit
  // und das Event-Sheet verwendet, weil diese noch
  // nicht mit Views arbeitet.
  final CalendricalEvent event;

  EventView({
    required this.groupID,
    this.courseName,
    required this.dateText,
    required this.title,
    required this.event,
    this.design,
  });

  factory EventView.fromEventAndGroupInfo(
    CalendricalEvent event,
    GroupInfo? info,
  ) {
    return EventView(
      groupID: event.groupID,
      courseName: info?.name,
      dateText: DateParser(event.date).toYMMMd,
      title: event.title,
      design: info?.design,
      event: event,
    );
  }
}
