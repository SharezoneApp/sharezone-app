// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_page.dart';

class _TimeTab extends StatelessWidget {
  const _TimeTab({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return StreamBuilder<TimeType>(
      stream: bloc.timeType,
      builder: (context, snapshot) {
        final timeType = snapshot.data ?? TimeType.period;
        return _TimetableAddSection(
          index: index,
          title: timeType == TimeType.period
              ? "In der wievielten Stunde findet die neue Schulstunde statt?"
              : "Wähle die Uhrzeit aus",
          child: _SwitchTimeType(timeType: timeType),
        );
      },
    );
  }
}

class _SwitchTimeType extends StatelessWidget {
  const _SwitchTimeType({required this.timeType});

  final TimeType timeType;

  @override
  Widget build(BuildContext context) {
    if (timeType == TimeType.period) {
      return Column(
        children: [
          const _NoteForChangingTheTimesOfTheTimetable(),
          _PeriodList(),
          _ChangeToIndividualButton(),
        ],
      );
    }
    return Column(
      children: <Widget>[
        _StartTime(),
        const SizedBox(height: 10),
        _EndTime(),
        _ChangeToPeriodButton(),
      ],
    );
  }
}

class _NoteForChangingTheTimesOfTheTimetable extends StatelessWidget {
  const _NoteForChangingTheTimesOfTheTimetable();

  @override
  Widget build(BuildContext context) {
    return const Opacity(
      opacity: 0.4,
      child: Text(
          "Du kannst die Stundenzeiten in den Einstellungen vom Stundenplan ändern.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12)),
    );
  }
}

class _ChangeToPeriodButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return TextButton(
      child: const Text(
        "Alternativ kannst du auch eine Stunde auswählen",
        textAlign: TextAlign.center,
      ),
      onPressed: () => bloc.changeTimeType(TimeType.period),
    );
  }
}

class _ChangeToIndividualButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return TextButton(
      child: const Text(
        "Alternativ kannst du auch individuell die Uhrzeit festlegen",
        textAlign: TextAlign.center,
      ),
      onPressed: () => bloc.changeTimeType(TimeType.individual),
    );
  }
}

class _PeriodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);
    return StreamBuilder<TimetableConfig>(
      stream: timetableBloc.stream,
      builder: (context, snapshot) {
        final config = snapshot.hasData ? snapshot.data : null;
        return StreamBuilder<Period?>(
          stream: bloc.period,
          builder: (context, snapshot2) {
            final selectedPeriod = snapshot2.data;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Wrap(
                spacing: 6,
                children: <Widget>[
                  for (final period
                      in config?.getPeriods().getPeriods() ?? <Period>[])
                    _PeriodTile(
                      period: period,
                      selectedPeriod: selectedPeriod,
                      onTap: () {
                        bloc.changePeriod(period);
                        navigateToNextTab(context);
                      },
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PeriodTile extends StatelessWidget {
  final Period period;
  final VoidCallback? onTap;
  final Period? selectedPeriod;

  const _PeriodTile({
    required this.period,
    this.onTap,
    this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = period == selectedPeriod;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 19,
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: (isSelected ? Colors.lightGreen : Colors.lightBlue)
              .withOpacity(0.20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: <Widget>[
                    Text(
                      period.number.toString(),
                      style: const TextStyle(fontSize: 26),
                    ),
                    const SizedBox(height: 2),
                    Opacity(
                        opacity: 0.7,
                        child: Text(
                          "${period.startTime} - ${period.endTime}",
                          style: const TextStyle(fontSize: 12),
                        )),
                  ],
                ),
              ),
              onTap: onTap),
        ),
      ),
    );
  }
}

class _StartTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return StreamBuilder<Time>(
      stream: bloc.startTime,
      builder: (context, snapshot) {
        final startTime = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: EditTimeField(
            time: startTime,
            onChanged: (startTime) async {
              bloc.changeStartTime(startTime);

              if (startTime.hour < 7) {
                showSnackSec(
                  text:
                      'Bitte bedenke, dass erst die Schulstunden ab 7 Uhr angezeigt werden.',
                  context: context,
                  seconds: 4,
                );
              }

              // Navigate to next Tab, if endTime is not Empty and startTime is before EndTime
              await waitingForPopAnimation();
              if (!context.mounted) return;

              try {
                if (bloc.isEndTimeValid()) {
                  navigateToNextTab(context);
                }
              } on Exception catch (e, s) {
                log('$e', error: e, stackTrace: s);

                showSnackSec(
                  text: handleErrorMessage(e.toString(), s),
                  context: context,
                );
              }
            },
            label: "Startzeit",
          ),
        );
      },
    );
  }
}

class _EndTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return StreamBuilder<Time>(
      stream: bloc.endTime,
      builder: (context, snapshot) {
        final endTime = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: EditTimeField(
            time: endTime,
            onChanged: (endTime) async {
              bloc.changeEndTime(endTime);

              // Navigate to next Tab, if startTime is not Empty and startTime is before EndTime
              await waitingForPopAnimation();
              if (!context.mounted) return;

              try {
                if (bloc.isStartTimeValid()) {
                  navigateToNextTab(context);
                }
              } on Exception catch (e, s) {
                log('$e', error: e, stackTrace: s);

                showSnackSec(
                  text: handleErrorMessage(e.toString(), s),
                  context: context,
                );
              }
            },
            label: "Endzeit",
          ),
        );
      },
    );
  }
}
