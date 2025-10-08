// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:interval_time_picker/models/visible_step.dart';
import 'package:sharezone/settings/src/subpages/timetable/time_picker_settings_cache.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

class EditTimeField extends StatelessWidget {
  final Time? time;
  final void Function(Time newTime) onChanged;
  final IconData? iconData;
  final String? label;
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  EditTimeField({
    super.key,
    required this.time,
    required this.onChanged,
    this.iconData,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            primary: Theme.of(context).primaryColor,
            seedColor: Theme.of(context).primaryColor,
            brightness:
                Theme.of(context).isDarkTheme
                    ? Brightness.dark
                    : Brightness.light,
          ),
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: isSelected,
          builder: (context, value, _) {
            return InkWell(
              child: InputDecorator(
                isEmpty: time == null,
                isFocused: value,
                decoration: InputDecoration(
                  labelText: label,
                  icon: const Icon(Icons.access_time),
                  border: const OutlineInputBorder(),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 18,
                    child:
                        time == null
                            ? Container()
                            : Text(
                              time!.toTimeOfDay().format(context),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                  ),
                ),
              ),
              onTap: () {
                isSelected.value = true;
                selectTime(context, initialTime: time).then((newTime) {
                  if (newTime != null) onChanged(newTime);
                  isSelected.value = false;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

Future<Time?> selectTime(
  BuildContext context, {
  Time? initialTime,
  int? minutesInterval,
  String title = "Wähle eine Uhrzeit",
}) async {
  final cache = BlocProvider.of<TimePickerSettingsCache>(context);
  final isFiveMinutesIntervalActive =
      await cache.isTimePickerWithFifeMinutesIntervalActiveStream().first;
  if (!context.mounted) return null;

  // We only use the five minutes interval on iOS, because only on iOS we have a
  // CupertinoTimePicker where 1 minute steps would slow users down
  // considerably. On other platforms, we use the interval time picker which has
  // a visible steps option.
  minutesInterval ??=
      (PlatformCheck.isIOS && isFiveMinutesIntervalActive) ? 5 : 1;

  if (PlatformCheck.isIOS) {
    return showDialog<TimeOfDay>(
      context: context,
      builder:
          (context) => CupertinoTimerPickerWithTimeOfDay(
            initialTime: initialTime?.toTimeOfDay(),
            minutesInterval: minutesInterval!,
            title: title,
          ),
    ).then((timeOfDay) {
      if (timeOfDay == null) return null;
      return Time.fromTimeOfDay(timeOfDay);
    });
  }

  return showIntervalTimePicker(
    context: context,
    initialTime:
        initialTime?.toTimeOfDay() ?? const TimeOfDay(hour: 9, minute: 10),
    interval: minutesInterval,
    visibleStep: minutesInterval.toVisibleStep(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
    initialEntryMode:
        PlatformCheck.isDesktopOrWeb
            ? TimePickerEntryMode.input
            : TimePickerEntryMode.dial,
  ).then((timeOfDay) {
    if (timeOfDay == null) return null;
    return Time.fromTimeOfDay(timeOfDay);
  });
}

class CupertinoTimerPickerWithTimeOfDay extends StatefulWidget {
  const CupertinoTimerPickerWithTimeOfDay({
    super.key,
    this.initialTime,
    required this.minutesInterval,
    this.title,
  });

  final TimeOfDay? initialTime;
  final int minutesInterval;
  final String? title;

  @override
  State createState() => _CupertinoTimerPickerWithTimeOfDayState();
}

class _CupertinoTimerPickerWithTimeOfDayState
    extends State<CupertinoTimerPickerWithTimeOfDay> {
  late TimeOfDay timeOfDay;

  @override
  void initState() {
    super.initState();
    timeOfDay = widget.initialTime ?? const TimeOfDay(hour: 9, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final initialTime =
        widget.initialTime ?? const TimeOfDay(hour: 9, minute: 0);
    return AlertDialog(
      title: isNotEmptyOrNull(widget.title) ? Text(widget.title!) : null,
      content: SizedBox(
        height: 250,
        width: 350,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              pickerTextStyle: TextStyle(
                color:
                    Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          child: CupertinoTimerPicker(
            initialTimerDuration: Duration(
              hours: initialTime.hour,
              minutes: initialTime.minute,
            ),
            minuteInterval: widget.minutesInterval,
            onTimerDurationChanged:
                (dur) => timeOfDay = timeOfDayFromDuration(dur),
            mode: CupertinoTimerPickerMode.hm,
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context, timeOfDay),
        ),
      ],
    );
  }

  TimeOfDay timeOfDayFromDuration(Duration dur) {
    final hours = dur.inHours % 24;
    final minutes = dur.inMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}

extension on int {
  VisibleStep toVisibleStep() {
    switch (this) {
      case 1:
      case 5:
        return VisibleStep.fifths;
      case 6:
        return VisibleStep.sixths;
      case 10:
        return VisibleStep.tenths;
      case 20:
        return VisibleStep.twentieths;
      case 30:
        return VisibleStep.thirtieths;
      case 60:
        return VisibleStep.sixtieth;
      default:
        // At the moment, only these intervals are supported. If you need
        // another one, please add it and handle it in the switch statement.
        throw Exception(
          "Unsupported minutes interval: $this. Please handle the other cases yourself.",
        );
    }
  }
}
