// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/timetable/src/logic/timetable_date_helper.dart';
import 'package:sharezone_widgets/theme.dart';

class TimetableWeekViewDayTile extends StatelessWidget {
  final Date date;
  final bool isToday;
  final bool showMonthName;

  const TimetableWeekViewDayTile({
    Key key,
    this.date,
    this.showMonthName = false,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Center(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    TimetableDateHelper.getDayOfWeek(date.weekDay),
                    style: Theme.of(context).textTheme.titleLarge.copyWith(
                        color: _getTextColorTitle(context), letterSpacing: 0.8),
                  ),
                ),
                decoration: _getDecoration(context),
              ),
              Text(
                _getDayOfMonthText(),
                style: Theme.of(context).textTheme.titleSmall.copyWith(
                      color: _getTextColorMonth(context),
                      fontSize: 12.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayOfMonthText() {
    return date.dayOfMonth.toString() +
        (showMonthName ? ". ${date.parser.toMMM}" : "");
  }

  Decoration _getDecoration(BuildContext context) {
    return isToday
        ? ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            color: isDarkThemeEnabled(context) ? Colors.white : darkBlueColor)
        : null;
  }

  Color _getTextColorTitle(BuildContext context) {
    return isToday
        ? isDarkThemeEnabled(context)
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.white
        : isDarkThemeEnabled(context)
            ? Colors.white
            : darkBlueColor;
  }

  Color _getTextColorMonth(BuildContext context) => isDarkThemeEnabled(context)
      ? Colors.white.withOpacity(0.7)
      : darkBlueColor.withOpacity(0.7);
}
