// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key? key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
    this.padding,
  }) : super(key: key);

  final String? labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? selectDate;
  final EdgeInsets? padding;

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime tomorrow = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? tomorrow,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectDate!(picked);
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(color: Colors.grey[500]);
    return Theme(
      data: Theme.of(context),
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _InputDropdown(
                iconData: Icons.today,
                labelText: labelText,
                valueText: selectedDate != null
                    ? DateFormat.yMMMd().format(selectedDate!)
                    : "Datum auswählen",
                valueStyle: valueStyle,
                padding: padding,
                onPressed: () async {
                  FocusScope.of(
                    context,
                  ).requestFocus(FocusNode()); // Close keyboard
                  await Future.delayed(
                    const Duration(milliseconds: 150),
                  ); // Waiting for closing keyboard
                  _selectDate(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key? key,
    this.iconData,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
    this.padding,
  }) : super(key: key);

  final String? labelText;
  final String? valueText;
  final TextStyle? valueStyle;

  final VoidCallback? onPressed;
  final IconData? iconData;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          //          labelText: labelText,
          border: InputBorder.none,
        ),
        baseStyle: valueStyle,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 4.0),
                  Icon(iconData, color: Colors.grey[500]),
                  SizedBox(width: 32.0),
                  labelText != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(labelText!, style: TextStyle(fontSize: 16.0)),
                            Text(valueText!, style: valueStyle),
                          ],
                        )
                      : Text(valueText!, style: TextStyle(fontSize: 16.0)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[600]
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
