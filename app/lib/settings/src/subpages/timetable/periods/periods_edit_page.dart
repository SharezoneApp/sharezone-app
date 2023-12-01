// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/settings/src/subpages/timetable/timetable_settings_page.dart';
import 'package:sharezone/settings/src/subpages/timetable/periods/periods_edit_bloc.dart';
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

void _showConfirmSnackBarOfSavingPeriods(BuildContext context) {
  showSnackSec(
    context: context,
    text: "Die Stundenzeiten wurden erfolgreich geändert.",
    behavior: SnackBarBehavior.fixed,
  );
}

Future<void> openPeriodsEditPage(BuildContext context) async {
  final result = await pushWithDefault<bool>(
    context,
    const _PeriodsEditPage(),
    defaultValue: false,
    name: _PeriodsEditPage.tag,
  );
  if (result && context.mounted) _showConfirmSnackBarOfSavingPeriods(context);
}

Future<void> _submit(
  BuildContext context, {
  PeriodsEditBloc? bloc,
  GlobalKey<ScaffoldMessengerState>? scaffoldKey,
}) async {
  bloc ??= BlocProvider.of<PeriodsEditBloc>(context);
  try {
    await bloc.submit();
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  } on Exception catch (e, s) {
    if (!context.mounted) return;
    showSnackSec(
      context: context,
      key: scaffoldKey,
      text: handleErrorMessage(e.toString(), s),
      seconds: 4,
      behavior: SnackBarBehavior.fixed,
    );
  }
}

class _PeriodsEditPage extends StatefulWidget {
  const _PeriodsEditPage({Key? key}) : super(key: key);

  static const tag = "periods-edit-page";

  @override
  __PeriodsEditPageState createState() => __PeriodsEditPageState();
}

class __PeriodsEditPageState extends State<_PeriodsEditPage> {
  late PeriodsEditBloc bloc;
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    final userSettingsBloc = BlocProvider.of<UserSettingsBloc>(context);
    final lessonLengthCache = BlocProvider.of<LessonLengthCache>(context);
    bloc = PeriodsEditBloc(userSettingsBloc, lessonLengthCache);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldPop = await warnUserAboutLeavingOrSavingForm(
          context,
          () => _submit(context, scaffoldKey: scaffoldKey, bloc: bloc),
        );
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: BlocProvider(
        bloc: bloc,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
          appBar: AppBar(title: const Text("Stundenzeiten"), centerTitle: true),
          body: StreamBuilder<Periods>(
            stream: bloc.periods,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final periods = snapshot.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      LessonsLengthField(
                        streamLessonLength: bloc.lessonLengthStream,
                        onChanged: (lessonLength) =>
                            bloc.saveLessonLengthInCache(lessonLength.minutes),
                      ),
                      const Divider(),
                      _TimetableStart(),
                      const Divider(),
                      for (final period in periods!.getPeriods())
                        _PeriodTile(
                          period: period,
                          isLastPeriod: periods.getPeriods().last == period,
                        ),
                      _AddTile(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: _PeriodsEditFAB(),
        ),
      ),
    );
  }
}

class _PeriodsEditFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Speichern',
      onPressed: () => _submit(context),
      child: const Icon(Icons.done),
    );
  }
}

class _AddTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PeriodsEditBloc>(context);
    return TextButton(
      onPressed: () => bloc.addPeriod(),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(
                    "Stunde hinzufügen",
                    style: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TimetableStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PeriodsEditBloc>(context);
    return StreamBuilder<Time>(
      stream: bloc.timetableStart,
      builder: (context, snapshot) {
        final time = snapshot.data ?? Time(hour: 7, minute: 30);
        return ListTile(
          title: const Text("Stundenplanbeginn"),
          subtitle: Text(time.toString()),
          onTap: () async {
            final newTime = await selectTime(context,
                initialTime: Time(hour: 8, minute: 0));
            if (newTime != null) {
              bloc.changeTimetableStart(newTime);
            }
          },
        );
      },
    );
  }
}

class _PeriodTile extends StatelessWidget {
  const _PeriodTile({
    Key? key,
    required this.period,
    required this.isLastPeriod,
  }) : super(key: key);

  final bool isLastPeriod;
  final Period period;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PeriodsEditBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  period.number.toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              // StreamBuilder<bool>(
              StreamBuilder<Set<int>>(
                stream: bloc.errorPeriod,
                builder: (context, snapshot) {
                  var style = Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 18);
                  if (snapshot.hasData &&
                      snapshot.data!.contains(period.number)) {
                    style = style.copyWith(
                        color: Theme.of(context).colorScheme.error);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Row(
                      children: <Widget>[
                        TextButton(
                            onPressed: () async {
                              final newTime = await selectTime(
                                context,
                                initialTime: period.startTime,
                                title:
                                    "Wähle eine Uhrzeit (${period.number}. Stunde)",
                              );
                              if (newTime != null) {
                                bloc.editPeriodStartTime(
                                    period.number, newTime);
                              }
                            },
                            child: Text(period.startTime.toString(),
                                style: style)),
                        Text("-", style: style),
                        TextButton(
                            onPressed: () async {
                              final newTime = await selectTime(context,
                                  initialTime: period.endTime);
                              if (newTime != null) {
                                bloc.editPeriodEndTime(period.number, newTime);
                              }
                            },
                            child:
                                Text(period.endTime.toString(), style: style)),
                      ],
                    ),
                  );
                },
              ),
              if (isLastPeriod)
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.redAccent,
                  onPressed: () => bloc.removePeriod(period),
                )
              else
                Container(width: 48)
            ],
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
