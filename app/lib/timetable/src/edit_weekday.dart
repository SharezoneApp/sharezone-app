// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/widgets/common/picker.dart';

Future<WeekDay?> selectWeekDay(BuildContext context, {WeekDay? selected}) {
  final userSettings =
      BlocProvider.of<SharezoneContext>(context).api.user.data!.userSettings;
  final enabledWeekDays = userSettings.enabledWeekDays.getEnabledWeekDaysList();
  return selectItem<WeekDay>(
    context: context,
    items: enabledWeekDays,
    builder: (context, item) {
      bool isSelected = selected == item;
      return ListTile(
        title: Text(item.toLocalizedString(context)),
        trailing:
            isSelected ? const Icon(Icons.done, color: Colors.green) : null,
        onTap: () {
          Navigator.pop(context, item);
        },
      );
    },
  );
}
