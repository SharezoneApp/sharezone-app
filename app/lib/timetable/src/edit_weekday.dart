import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:sharezone/widgets/common/picker.dart';

String getWeekDayText(WeekDay weekDay) {
  switch (weekDay) {
    case WeekDay.monday:
      return "Montag";
    case WeekDay.tuesday:
      return "Dienstag";
    case WeekDay.wednesday:
      return "Mittwoch";
    case WeekDay.thursday:
      return "Donnerstag";
    case WeekDay.friday:
      return "Freitag";
    case WeekDay.saturday:
      return "Samstag";
    case WeekDay.sunday:
      return "Sonntag";
    default:
      return "???";
  }
}

Future<WeekDay> selectWeekDay(BuildContext context, {WeekDay selected}) {
  final userSettings =
      BlocProvider.of<SharezoneContext>(context).api.user.data.userSettings;
  final enabledWeekDays = userSettings.enabledWeekDays.getEnabledWeekDaysList();
  return selectItem<WeekDay>(
    context: context,
    items: enabledWeekDays,
    builder: (context, item) {
      bool isSelected = selected == item;
      return ListTile(
        title: Text(getWeekDayText(item)),
        trailing: isSelected
            ? Icon(
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
