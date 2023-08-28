// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_page.dart';

class _WeekDayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return _TimetableAddSection(
      index: 2,
      title: 'Wähle einen Wochentag aus',
      child: StreamBuilder<WeekDay>(
        stream: bloc.weekDay,
        builder: (context, snapshot) {
          final selectedWeekDay = snapshot.data;
          return _WeekDayList(selectedWeekDay);
        },
      ),
    );
  }
}

class _WeekDayList extends StatelessWidget {
  const _WeekDayList(this.selectedWeekDay);

  final WeekDay? selectedWeekDay;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    final userSettings =
        BlocProvider.of<SharezoneContext>(context).api.user.data!.userSettings;
    final enabledWeekDays =
        userSettings.enabledWeekDays.getEnabledWeekDaysList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Column(
            children: [
              for (final weekDay in enabledWeekDays)
                _WeekDayTile(
                  weekDay: weekDay,
                  selectedWeekDay: selectedWeekDay,
                  onTap: () async {
                    bloc.changeWeekDay(weekDay);
                    await waitingForPopAnimation();
                    navigateToNextTab(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDayTile extends StatelessWidget {
  const _WeekDayTile({
    Key? key,
    required this.weekDay,
    this.onTap,
    this.selectedWeekDay,
  }) : super(key: key);

  final WeekDay weekDay;
  final VoidCallback? onTap;
  final WeekDay? selectedWeekDay;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = weekDay == selectedWeekDay;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        clipBehavior: Clip.antiAlias,
        child: ListTile(title: Text(getWeekDayText(weekDay)), onTap: onTap),
        color: (isSelected ? Colors.lightGreen : Colors.lightBlue)
            .withOpacity(0.20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
