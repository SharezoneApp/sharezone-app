// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:clock/clock.dart';
import 'package:date/date.dart';
import 'package:date/weektype.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:platform_check/platform_check.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/ical_links/list/ical_links_page.dart';
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:sharezone/settings/src/subpages/timetable/bloc/timetable_settings_bloc.dart';
import 'package:sharezone/settings/src/subpages/timetable/bloc/timetable_settings_bloc_factory.dart';
import 'package:sharezone/settings/src/subpages/timetable/periods/periods_edit_page.dart';
import 'package:sharezone/settings/src/subpages/timetable/weekdays/weekdays_edit_page.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class TimetableSettingsPage extends StatelessWidget {
  static const String tag = 'timetable-settings-page';

  const TimetableSettingsPage({super.key});
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
                  _TimetablePeriodsField(),
                  const Divider(),
                  _ABWeekField(),
                  const Divider(),
                  _AbbreviationInTimetable(),
                  const Divider(),
                  _TimetableEnabledWeekDaysField(),
                  const Divider(),
                  const _ICalLinks(),
                  // We only show the time picker settings on iOS because on
                  // other platforms we use the different time picker where we
                  // have a visible steps option.
                  if (PlatformCheck.isIOS) ...[
                    const Divider(),
                    _IsTimePickerFifeMinutesIntervalActive(),
                  ],
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
          return const CircularProgressIndicator();
        }
        final userSettings = snapshot.data;
        return Column(
          children: <Widget>[
            SwitchListTile.adaptive(
              title: const Text("A/B Wochen"),
              value: userSettings!.isABWeekEnabled,
              onChanged: (newValue) {
                bloc.updateSettings(
                  userSettings.copyWith(isABWeekEnabled: newValue),
                );
              },
            ),
            if (userSettings.isABWeekEnabled) ...[
              InkWell(
                onTap:
                    () => bloc.updateSettings(
                      userSettings.copyWith(
                        isAWeekEvenWeek: !userSettings.isAWeekEvenWeek,
                      ),
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text("A-Wochen sind gerade Kalenderwochen"),
                      trailing: Switch.adaptive(
                        value: userSettings.isAWeekEvenWeek,
                        onChanged:
                            (newValue) => bloc.updateSettings(
                              userSettings.copyWith(isAWeekEvenWeek: newValue),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(
                        "Diese Woche ist Kalenderwoche ${getWeekNumber(clock.now()).toString()}. A-Wochen sind ${_getAWeekIsEvenOrOddName(userSettings.isAWeekEvenWeek)} Kalenderwochen und somit ist aktuell eine ${_getCurrentWeekTypeName(userSettings.isAWeekEvenWeek)}.",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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
    final isCurrentWeekEven = getWeekNumber(clock.now()).isEven;
    if (isCurrentWeekEven) {
      return isAWeekEvenWeek ? WeekType.a : WeekType.b;
    } else {
      return isAWeekEvenWeek ? WeekType.b : WeekType.a;
    }
  }
}

class _AbbreviationInTimetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserSettingsBloc>(context);
    return StreamBuilder<UserSettings>(
      stream: bloc.streamUserSettings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        final userSettings = snapshot.data!;
        return SwitchListTile.adaptive(
          title: const Text("Kürzel im Stundenplan anzeigen"),
          value: userSettings.showAbbreviation,
          onChanged: (newValue) {
            bloc.updateSettings(
              userSettings.copyWith(showAbbreviation: newValue),
            );
          },
        );
      },
    );
  }
}

class _TimetablePeriodsField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Stundenzeiten"),
      subtitle: const Text("Stundenplanbeginn, Stundenlänge, etc."),
      onTap: () => openPeriodsEditPage(context),
    );
  }
}

class _ICalLinks extends StatelessWidget {
  const _ICalLinks();

  @override
  Widget build(BuildContext context) {
    final isUnlocked = context.read<SubscriptionService>().hasFeatureUnlocked(
      SharezonePlusFeature.iCalLinks,
    );
    return ListTile(
      title: const Text("Termine, Prüfungen, Stundenplan exportieren (iCal)"),
      subtitle: const Text(
        "Synchronisierung mit Google Kalender, Apple Kalender usw.",
      ),
      onTap: () {
        if (isUnlocked) {
          Navigator.pushNamed(context, ICalLinksPage.tag);
        } else {
          showSharezonePlusFeatureInfoDialog(
            context: context,
            navigateToPlusPage:
                () => openSharezonePlusPageAsFullscreenDialog(context),
            description: const Text(
              'Mit einem iCal-Link kannst du deinen Stundenplan und deine Termine in andere Kalender-Apps (wie z.B. Google Kalender, Apple Kalender) einbinden. Sobald sich dein Stundenplan oder deine Termine ändern, werden diese auch in deinen anderen Kalender Apps aktualisiert.\n\nAnders als beim "Zum Kalender hinzufügen" Button, musst du dich nicht darum kümmern, den Termin in deiner Kalender App zu aktualisieren, wenn sich etwas in Sharezone ändert.\n\niCal-Links ist nur für dich sichtbar und können nicht von anderen Personen eingesehen werden.\n\nBitte beachte, dass aktuell nur Termine und Prüfungen exportiert werden können. Die Schulstunden können noch nicht exportiert werden.',
            ),
          );
        }
      },
      trailing: isUnlocked ? null : const SharezonePlusChip(),
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

class LessonsLengthField extends StatelessWidget {
  const LessonsLengthField({
    super.key,
    required this.streamLessonLength,
    required this.onChanged,
  });

  final Stream<LessonLength> streamLessonLength;
  final ValueChanged<LessonLength> onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LessonLength>(
      stream: streamLessonLength,
      builder: (context, snapshot) {
        final lessonLength = snapshot.data ?? LessonLength.standard();
        return InkWell(
          borderRadius: splashBorderRadius,
          onTap: () async {
            final selectedLessonLength = await showNumberPickerDialog(
              context,
              lessonLength.minutes,
            );
            if (selectedLessonLength.isValid &&
                selectedLessonLength != lessonLength &&
                context.mounted) {
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
                mouseCursor: SystemMouseCursors.click,
                trailing: Text(
                  lessonLength.isValid ? "${lessonLength.minutes} Min." : "-",
                ),
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
    BuildContext context,
    int initialLengthInMinutes,
  ) async {
    final selectedLengthInMinutes = await showDialog<int>(
      context: context,
      builder:
          (context) => _NumberPicker(initialLength: initialLengthInMinutes),
    );

    return LessonLength(selectedLengthInMinutes ?? initialLengthInMinutes);
  }

  void _showConfirmationSnackBar(BuildContext context) {
    showSnack(
      context: context,
      duration: const Duration(milliseconds: 1500),
      text: 'Länge einer Stunde wurde gespeichert.',
    );
  }
}

class _NumberPicker extends StatefulWidget {
  const _NumberPicker({required this.initialLength});

  final int initialLength;

  @override
  __NumberPickerState createState() => __NumberPickerState();
}

class __NumberPickerState extends State<_NumberPicker> {
  late int value;

  @override
  void initState() {
    value = widget.initialLength;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wähle die Länge der Stunde in Minuten aus.'),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Bestätigen'),
          onPressed: () {
            Navigator.pop(context, value);
          },
        ),
      ],
      // Needed to work on the web.
      // See: https://github.com/MarcinusX/NumberPicker/issues/118
      content: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: NumberPicker(
          minValue: 1,
          maxValue: 300,
          value: value,
          onChanged: (newValue) => setState(() => value = newValue),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
      ),
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
