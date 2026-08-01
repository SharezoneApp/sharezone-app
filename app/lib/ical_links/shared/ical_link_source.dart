// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

/// The sources for which an iCal link includes.
enum ICalLinkSource {
  exams,
  meetings,
  lessons;

  String getUiName() {
    return switch (this) {
      ICalLinkSource.lessons => 'Lessons',
      ICalLinkSource.exams => 'Exams',
      ICalLinkSource.meetings => 'Events',
    };
  }

  Widget getIcon() {
    return switch (this) {
      ICalLinkSource.lessons => const Icon(Icons.timelapse),
      ICalLinkSource.exams => const Icon(Icons.school),
      ICalLinkSource.meetings => const Icon(Icons.event),
    };
  }
}
