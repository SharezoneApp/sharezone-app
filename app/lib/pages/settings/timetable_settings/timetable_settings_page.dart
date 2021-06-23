import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/date.dart';
import 'package:sharezone/pages/settings/timetable_settings/bloc/timetable_settings_bloc.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:time/time.dart';
import 'package:date/weektype.dart';
import 'package:user/user.dart';
import 'package:sharezone/pages/settings/timetable_settings/bloc/timetable_settings_bloc_factory.dart';
import 'package:sharezone/settings/periods_edit_page.dart';
import 'package:sharezone/settings/weekdays_edit_page.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:sharezone_widgets/snackbars.dart';

class TimetableSettingsPage extends StatelessWidget {
  static const String tag = 'timetable-settings-page';
  @override
  Widget build(BuildContext context) {
    final bloc =
        BlocProvider.of<TimetableSettingsBlocFactory>(context).create();
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Stundenplan"), centerTitle: true),
        body: SingleChildScrollView(
          child: SafeArea(
            child: MaxWidthConstraintBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LessonsLengthField(
                    streamLessonLength: bloc.lessonLengthStream,
                    onChanged: (lessonLength) =>
                        bloc.saveLessonLengthInCache(lessonLength.minutes),
                  ),
                  Divider(),
                  _ABWeekField(),
                  Divider(),
                  _TimetablePreferencesField(),
                  Divider(),
                  _TimetableEnabledWeekDaysField(),
                  Divider(),
                  _TimetablePeriodsField(),
                  Divider(),
                  _IsTimePickerFifeMinutesIntervalActive(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ABWeekField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserSettingsBloc>(context);
    return StreamBuilder<UserSettings>(
      stream: bloc.streamUserSettings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final userSettings = snapshot.data;
        return Column(
          children: <Widget>[
            SwitchListTile.adaptive(
              title: const Text("A/B Wochen"),
              value: userSettings.isABWeekEnabled,
              onChanged: (newValue) {
                bloc.updateSettings(
                    userSettings.copyWith(isABWeekEnabled: newValue));
              },
            ),
            if (userSettings.isABWeekEnabled) ...[
              InkWell(
                onTap: () => bloc.updateSettings(userSettings.copyWith(
                    isAWeekEvenWeek: !userSettings.isAWeekEvenWeek)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text("A-Wochen sind gerade Kalenderwochen"),
                      trailing: Switch.adaptive(
                        value: userSettings.isAWeekEvenWeek,
                        onChanged: (newValue) => bloc.updateSettings(
                            userSettings.copyWith(isAWeekEvenWeek: newValue)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(
                        "Diese Woche ist Kalenderwoche ${getWeekNumber(DateTime.now()).toString()}. A-Wochen sind ${_getAWeekIsEvenOrOddName(userSettings.isAWeekEvenWeek)} Kalenderwochen und somit ist aktuell eine ${_getCurrentWeekTypeName(userSettings.isAWeekEvenWeek)}.",
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _getAWeekIsEvenOrOddName(bool isAWeekEvenWeek) {
    return isAWeekEvenWeek ? "gerade" : "ungerade";
  }

  String _getCurrentWeekTypeName(bool isAWeekEvenWeek) {
    return getWeekTypeText(_getCurrentWeekType(isAWeekEvenWeek));
  }

  WeekType _getCurrentWeekType(bool isAWeekEvenWeek) {
    final _isCurrentWeekEven = getWeekNumber(DateTime.now()).isEven;
    if (_isCurrentWeekEven) {
      return isAWeekEvenWeek ? WeekType.a : WeekType.b;
    } else {
      return isAWeekEvenWeek ? WeekType.b : WeekType.a;
    }
  }
}

class _TimetablePeriodsField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Stundenzeiten"),
      onTap: () => openPeriodsEditPage(context),
    );
  }
}

class _TimetableEnabledWeekDaysField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Aktivierte Wochentage"),
      onTap: () => openWeekDaysEditPage(context),
    );
  }
}

class _TimetablePreferencesField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserSettingsBloc>(context);
    return StreamBuilder<UserSettings>(
      stream: bloc.streamUserSettings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        final userSettings = snapshot.data;
        final tbStart = userSettings.timetableStartTime;
        return Column(
          children: <Widget>[
            ListTile(
              title: const Text("Stundenplanbeginn"),
              subtitle: Text(tbStart.time),
              onTap: () async {
                final newTime = await selectTime(context,
                    initialTime: Time(hour: 8, minute: 0));
                if (newTime != null) {
                  bloc.updateTimetableStartTime(newTime);
                }
              },
            ),
            Divider(),
            SwitchListTile.adaptive(
              title: const Text("Kürzel im Stundenplan anzeigen"),
              value: userSettings.showAbbreviation,
              onChanged: (newValue) {
                bloc.updateSettings(
                    userSettings.copyWith(showAbbreviation: newValue));
              },
            ),
          ],
        );
      },
    );
  }
}

class LessonsLengthField extends StatelessWidget {
  const LessonsLengthField({
    Key key,
    @required this.streamLessonLength,
    @required this.onChanged,
  }) : super(key: key);

  final Stream<LessonLength> streamLessonLength;
  final ValueChanged<LessonLength> onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LessonLength>(
      stream: streamLessonLength,
      builder: (context, snapshot) {
        final lessonLength = snapshot.data ?? LessonLength.standard();
        return InkWell(
          onTap: () async {
            final selectedLessonLength =
                await showNumberPickerDialog(context, lessonLength.minutes);
            if (selectedLessonLength.isValid) {
              onChanged(selectedLessonLength);
              _showConfirmationSnackBar(context);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.timelapse),
                title: const Text("Länge einer Stunde"),
                trailing: Text(lessonLength.isValid
                    ? "${lessonLength.minutes} Min."
                    : "-"),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  "Solltest du eine neue Schulstunde eintragen, wird beim Eintragen der Startzeit automatisch die Endzeit basierend auf der Länge der Stunde berechnet.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<LessonLength> showNumberPickerDialog(
      BuildContext context, int initalLengthInMinutes) async {
    final selectedLengthInMinutes = await showDialog<int>(
      context: context,
      builder: (context) => NumberPickerDialog.integer(
        minValue: 1,
        maxValue: 300,
        cancelWidget: const Text("ABBRECHEN"),
        title: const Text("Wähle die Länge der Stunde in Minuten aus."),
        initialIntegerValue: initalLengthInMinutes ?? 45,
      ),
    );
    return LessonLength(selectedLengthInMinutes);
  }

  void _showConfirmationSnackBar(BuildContext context) {
    showSnack(
      context: context,
      duration: const Duration(milliseconds: 1500),
      text: 'Länge einer Stunde wurde gespeichert.',
    );
  }
}

class _IsTimePickerFifeMinutesIntervalActive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableSettingsBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isTimePickerFifeMinutesIntervalActive,
      builder: (context, snapshot) {
        final isActive = snapshot.data ?? true;
        return SwitchListTile.adaptive(
          title: const Text("Fünf-Minuten-Intervall beim Time-Picker"),
          value: isActive,
          onChanged: bloc.setIsTimePickerFifeMinutesIntervalActive,
        );
      },
    );
  }
}
