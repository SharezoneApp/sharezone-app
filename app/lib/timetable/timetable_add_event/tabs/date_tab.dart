// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

part of '../timetable_add_event_page.dart';

class _DateTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return _TimetableAddSection(
      index: 3,
      title: 'Wähle ein Datum aus',
      child: StreamBuilder<Date>(
        stream: bloc.date,
        builder: (context, snapshot) {
          final selectedWeekDay = snapshot.hasData ? snapshot.data : null;
          return _DateField(selectedWeekDay);
        },
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField(this.selectedDate);

  final Date? selectedDate;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: EditDateField(
            date: selectedDate,
            onChanged: (newDate) {
              bloc.changeDate(newDate);
              navigateToNextTab(context);
            },
          ),
        ),
      ),
    );
  }
}
