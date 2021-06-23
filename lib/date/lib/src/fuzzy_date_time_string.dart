import 'package:flutter/material.dart';

import 'date.dart';

String getFuzzyDateTimeString(BuildContext context, DateTime dateTime) {
  final dateOfDateTime = Date.fromDateTime(dateTime);
  final dateToday = Date.today();
  if (dateOfDateTime.isSameDay(dateToday)) {
    return TimeOfDay.fromDateTime(dateTime).format(context);
  } else {
    final dateYesterday = dateToday.addDays(-1);
    if (dateOfDateTime.isSameDay(dateYesterday))
      return 'Gestern';
    else {
      if (dateOfDateTime.year == dateToday.year)
        return dateOfDateTime.parser.toMMMEd;
      else
        return dateOfDateTime.parser.toYMMMd;
    }
  }
}
