// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:date/date.dart';
import 'package:flutter/material.dart';

class EditDateField extends StatelessWidget {
  final Date? date;
  final void Function(Date newDate) onChanged;
  final IconData? iconData;
  final String? label;
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  EditDateField({
    required this.date,
    required this.onChanged,
    this.iconData,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 6,
        right: 6,
        top: 6,
        bottom: 6,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelected,
        builder: (context, value, _) {
          return InkWell(
            child: InputDecorator(
              isEmpty: date == null,
              isFocused: value,
              decoration: InputDecoration(
                labelText: label ?? "Datum auswählen",
                icon: Icon(iconData ?? Icons.today),
                border: const OutlineInputBorder(),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18,
                  child: date == null
                      ? Container()
                      : Text(date!.parser.toYMMMMEEEEd,
                          style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
            onTap: () {
              isSelected.value = true;
              selectDate(context, initialDate: date).then((newDate) {
                if (newDate != null) onChanged(newDate);
                isSelected.value = false;
              });
            },
          );
        },
      ),
    );
  }
}

Future<Date?> selectDate(
  BuildContext context, {
  Date? initialDate,
}) async {
  return showDatePicker(
    context: context,
    initialDate: initialDate?.toDateTime ?? DateTime.now(),
    firstDate: Date("2019-01-01").toDateTime,
    lastDate: Date("2029-12-31").toDateTime,
  ).then((newDateTime) {
    if (newDateTime != null) {
      return Date.fromDateTime(newDateTime);
    } else {
      return null;
    }
  });
}
