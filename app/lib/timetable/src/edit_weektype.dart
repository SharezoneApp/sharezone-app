// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:date/weektype.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/widgets/common/picker.dart';

String getWeekTypeText(WeekType weekDay) {
  switch (weekDay) {
    case WeekType.always:
      return "Always (no A/B week cycle)";
    case WeekType.a:
      return "A week";
    case WeekType.b:
      return "B week";
  }
}

String getWeekTypeTextShort(WeekType weekDay) {
  switch (weekDay) {
    case WeekType.always:
      return "0";
    case WeekType.a:
      return "A";
    case WeekType.b:
      return "B";
  }
}

Future<WeekType?> selectWeekType(
  BuildContext context, {
  WeekType? selected,
}) async {
  return await selectItem<WeekType>(
    context: context,
    items: WeekType.values.toList(),
    builder: (context, item) {
      final isSelected = selected == item;
      return ListTile(
        title: Text(getWeekTypeText(item)),
        trailing:
            isSelected ? const Icon(Icons.done, color: Colors.green) : null,
        onTap: () {
          log("Selected week type: ${getWeekTypeText(item)}");
          Navigator.pop(context, item);
        },
      );
    },
  );
}
