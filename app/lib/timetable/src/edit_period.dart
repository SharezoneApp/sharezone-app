// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/widgets/common/picker.dart';
import 'package:user/user.dart';

import 'bloc/timetable_bloc.dart';

Future<Period?> selectPeriod(BuildContext context, {Period? selected}) {
  final bloc = BlocProvider.of<TimetableBloc>(context);
  final periods = bloc.current.getPeriods();
  return selectItem<Period>(
    context: context,
    items: periods.getPeriods(),
    builder: (context, item) {
      bool isSelected = selected == item;
      return ListTile(
        leading: Text(
          item.number.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        title: Text("${item.startTime} - ${item.endTime}"),
        trailing: isSelected
            ? const Icon(
                Icons.done,
                color: Colors.green,
              )
            : null,
        onTap: () {
          Navigator.pop(context, item);
        },
      );
    },
  );
}
