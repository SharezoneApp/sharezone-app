import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/pages/settings/timetable_settings/time_picker_settings_cache.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:time/time.dart';
import 'package:sharezone_common/helper_functions.dart';

class EditTimeField extends StatelessWidget {
  final Time time;
  final void Function(Time newTime) onChanged;
  final IconData iconData;
  final String label;
  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  EditTimeField({
    @required this.time,
    @required this.onChanged,
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
                  child: time == null
                      ? Container()
                      : Text(time.toTimeOfDay().format(context),
                          style: TextStyle(fontSize: 16.0)),
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
    );
  }
}

Future<Time> selectTime(BuildContext context,
    {Time initialTime,
    int minutesInterval,
    String title = "Wähle eine Uhrzeit"}) async {
  final cache = BlocProvider.of<TimePickerSettingsCache>(context);
  final isFiveMinutesIntervalActive =
      await cache.isTimePickerWithFifeMinutesIntervalActiveStream().first ??
          true;

  if (PlatformCheck.isIOS) {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (context) => CupertinoTimerPickerWithTimeOfDay(
        initalTime: initialTime?.toTimeOfDay(),
        minutesInterval:
            minutesInterval ?? (isFiveMinutesIntervalActive ? 5 : 1),
        title: title,
      ),
    ).then((timeOfDay) => Time.fromTimeOfDay(timeOfDay));
  }

  return showTimePicker(
    context: context,
    initialTime: initialTime?.toTimeOfDay() ?? TimeOfDay(hour: 9, minute: 10),
    cancelText: 'Abbrechen'.toUpperCase(),
    builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );
    },
    initialEntryMode: PlatformCheck.isDesktopOrWeb
        ? TimePickerEntryMode.input
        : TimePickerEntryMode.dial,
  ).then((timeOfDay) => Time.fromTimeOfDay(timeOfDay));
}

class CupertinoTimerPickerWithTimeOfDay extends StatefulWidget {
  const CupertinoTimerPickerWithTimeOfDay(
      {Key key, this.initalTime, this.minutesInterval, this.title})
      : super(key: key);

  final TimeOfDay initalTime;
  final int minutesInterval;
  final String title;

  @override
  _CupertinoTimerPickerWithTimeOfDayState createState() =>
      _CupertinoTimerPickerWithTimeOfDayState();
}

class _CupertinoTimerPickerWithTimeOfDayState
    extends State<CupertinoTimerPickerWithTimeOfDay> {
  TimeOfDay timeOfDay;

  @override
  void initState() {
    super.initState();
    timeOfDay = widget.initalTime ?? TimeOfDay(hour: 9, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final initalTime = widget.initalTime ?? TimeOfDay(hour: 9, minute: 0);
    return AlertDialog(
      title: isNotEmptyOrNull(widget.title) ? Text(widget.title) : null,
      content: SizedBox(
        height: 250,
        width: 350,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              pickerTextStyle: TextStyle(
                color:
                    isDarkThemeEnabled(context) ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          child: CupertinoTimerPicker(
            initialTimerDuration: Duration(
              hours: initalTime.hour,
              minutes: initalTime.minute,
            ),
            minuteInterval: widget.minutesInterval,
            onTimerDurationChanged: (dur) =>
                timeOfDay = timeOfDayFromDuration(dur),
            mode: CupertinoTimerPickerMode.hm,
            backgroundColor: Theme.of(context).dialogBackgroundColor,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context, timeOfDay),
        )
      ],
    );
  }

  TimeOfDay timeOfDayFromDuration(Duration dur) {
    final hours = dur.inHours % 24;
    final minutes = dur.inMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
