// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../timetable_add_event_page.dart';

class _TimeTab extends StatelessWidget {
  const _TimeTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TimetableAddSection(
      index: 4,
      title: "Wähle die Uhrzeit aus",
      child: Column(
        children: <Widget>[
          _StartTime(),
          const SizedBox(height: 10),
          _EndTime(),
        ],
      ),
    );
  }
}

class _StartTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
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

              // Navigate to next Tab, if endTime is not Empty and startTime is before EndTime
              await waitingForPopAnimation();
              try {
                if (bloc.isEndTimeValid()) {
                  navigateToNextTab(context);
                }
              } on Exception catch (e, s) {
                print(e);
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
    final bloc = BlocProvider.of<TimetableAddEventBloc>(context);
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
              try {
                if (bloc.isStartTimeValid()) {
                  navigateToNextTab(context);
                }
              } on Exception catch (e, s) {
                print(e);
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
