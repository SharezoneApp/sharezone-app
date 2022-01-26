// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_page.dart';

class _WeekTypeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return _TimetableAddSection(
      index: 3,
      title: 'Wähle einen Wochentypen aus',
      child: StreamBuilder<WeekType>(
        stream: bloc.weekType,
        builder: (context, snapshot) {
          final selectedWeekType = snapshot.hasData ? snapshot.data : null;
          return _WeekTypeList(selectedWeekType);
        },
      ),
    );
  }
}

class _WeekTypeList extends StatelessWidget {
  const _WeekTypeList(this.selectedWeekType);

  final WeekType selectedWeekType;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddBloc>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Column(
            children: (WeekType.values).map((weektype) {
              return _WeekTypeTile(
                weekType: weektype,
                selectedWeekType: selectedWeekType,
                onTap: () {
                  bloc.changeWeekType(weektype);
                  Future.delayed(const Duration(milliseconds: 200)).then((_) {
                    navigateToNextTab(context);
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _WeekTypeTile extends StatelessWidget {
  final WeekType weekType;
  final VoidCallback onTap;
  final WeekType selectedWeekType;

  const _WeekTypeTile(
      {Key key, this.weekType, this.onTap, this.selectedWeekType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = weekType == selectedWeekType;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Text(getWeekTypeText(weekType)),
          onTap: onTap,
        ),
        color: (isSelected ? Colors.lightGreen : Colors.lightBlue)
            .withOpacity(0.20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
