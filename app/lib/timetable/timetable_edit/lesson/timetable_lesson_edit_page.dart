// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/edit_period.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/src/edit_weekday.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/timetable_page/lesson/timetable_lesson_sheet.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone/util/api/connectionsGateway.dart';
import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

import 'timetable_lesson_edit_bloc.dart';

void _submit(BuildContext context) {
  final bloc = BlocProvider.of<TimetableEditBloc>(context);
  try {
    bloc.submit();
    Navigator.pop(context, true);
  } on Exception catch (e, s) {
    print(e);
    showSnackSec(text: handleErrorMessage(e.toString(), s), context: context);
  }
}

class TimetableEditLessonPage extends StatefulWidget {
  static const tag = "timetable-lesson-edit-page";

  final TimetableGateway timetableGateway;
  final ConnectionsGateway connectionsGateway;
  final TimetableBloc timetableBloc;
  final Lesson initialLesson;
  const TimetableEditLessonPage(this.initialLesson, this.timetableGateway,
      this.connectionsGateway, this.timetableBloc);

  @override
  _TimetableEditLessonPageState createState() => _TimetableEditLessonPageState(
      initialLesson, timetableGateway, connectionsGateway, timetableBloc);
}

class _TimetableEditLessonPageState extends State<TimetableEditLessonPage> {
  final TimetableGateway timetableGateway;
  final ConnectionsGateway connectionsGateway;
  final TimetableBloc timetableBloc;
  final Lesson initialLesson;
  TimetableEditBloc bloc;

  _TimetableEditLessonPageState(this.initialLesson, this.timetableGateway,
      this.connectionsGateway, this.timetableBloc);

  @override
  void initState() {
    bloc = TimetableEditBloc(
      initialLesson: initialLesson,
      gateway: timetableGateway,
      connectionsGateway: connectionsGateway,
      timetableBloc: timetableBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: _TimetableEditPage(initialLesson),
    );
  }
}

class _TimetableEditPage extends StatelessWidget {
  final Lesson initalLesson;

  const _TimetableEditPage(this.initalLesson, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);
    return WillPopScope(
      onWillPop: () =>
          warnUserAboutLeavingOrSavingForm(context, () => _submit(context)),
      child: Scaffold(
        backgroundColor: isDarkThemeEnabled(context) ? null : Colors.white,
        appBar: AppBar(title: const Text("Schulstunde bearbeiten")),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 6),
              _CourseField(initalLesson),
              const Divider(),
              _WeekDayField(),
              if (timetableBloc.current.isABWeekEnabled()) ...[
                const Divider(),
                _WeekTypeField(),
              ],
              const Divider(),
              _PeriodField(),
              const Divider(),
              _StartTimeField(),
              const Divider(),
              _EndTimeField(),
              const Divider(height: 8),
              _RoomField(initalLesson),
            ],
          ),
        ),
        floatingActionButton: _TimetableEditFAB(),
      ),
    );
  }
}

class _TimetableEditFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Speichern',
      heroTag: 'sharezone-fab',
      child: const Icon(Icons.done),
      onPressed: () => _submit(context),
    );
  }
}

class _CourseField extends StatelessWidget {
  const _CourseField(this.initalLesson, {Key key}) : super(key: key);

  final Lesson initalLesson;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    final timetableGateway =
        BlocProvider.of<SharezoneContext>(context).api.timetable;
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final hasPermissionsToManageLessons = hasPermissionToManageLessons(
        api.course.getRoleFromCourseNoSync(initalLesson.groupID));
    return StreamBuilder<Course>(
      stream: bloc.course,
      builder: (context, snapshot) {
        final course = snapshot.hasData ? snapshot.data : null;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightBlue,
            child: Text(course?.abbreviation ?? ""),
            foregroundColor: Colors.white,
          ),
          title: Text(course?.name ?? ""),
          onTap: () {
            showSnackSec(
              context: context,
              text: "Der Kurs kann nicht mehr nachträglich geändert werden.",
              seconds: 4,
              action: hasPermissionsToManageLessons
                  ? SnackBarAction(
                      label: 'Stunde löschen'.toUpperCase(),
                      textColor: Colors.lightBlueAccent,
                      onPressed: () async {
                        final confirmed =
                            await showDeleteLessonConfirmationDialog(context);
                        if (confirmed != null && confirmed) {
                          timetableGateway.deleteLesson(initalLesson);
                          Navigator.pop(context);
                        }
                      },
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}

class _WeekDayField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    return StreamBuilder<WeekDay>(
      stream: bloc.weekDay,
      builder: (context, snapshot) {
        final weekDay = snapshot.hasData ? snapshot.data : null;
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: const Icon(Icons.today),
          ),
          title: Text(getWeekDayText(weekDay)),
          onTap: () async {
            final newWeekDay = await selectWeekDay(context, selected: weekDay);
            if (newWeekDay != null) {
              bloc.changeWeekDay(newWeekDay);
            }
          },
        );
      },
    );
  }
}

class _PeriodField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    return StreamBuilder<Period>(
      stream: bloc.period,
      builder: (context, snapshot) {
        final period = snapshot.hasData ? snapshot.data : null;
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: const Icon(Icons.timeline),
          ),
          title: Text(period != null
              ? "${period?.number}. Stunde"
              : "Keine Stunde ausgewählt"),
          onTap: () async {
            final newPeriod = await selectPeriod(context, selected: period);
            if (newPeriod != null) {
              bloc.changePeriod(newPeriod);
            }
          },
        );
      },
    );
  }
}

class _WeekTypeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    return StreamBuilder<WeekType>(
      stream: bloc.weekType,
      builder: (context, snapshot) {
        final weekType = snapshot.hasData ? snapshot.data : null;
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: const Icon(Icons.swap_horiz),
          ),
          title: Text(getWeekTypeText(weekType)),
          onTap: () async {
            final newWeekType =
                await selectWeekType(context, selected: weekType);
            if (newWeekType != null) {
              print("WeekType beim Change: ${getWeekTypeText(weekType)}");
              bloc.changeWeekType(newWeekType);
            }
          },
        );
      },
    );
  }
}

class _StartTimeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    return StreamBuilder<Time>(
      stream: bloc.startTime,
      builder: (context, snapshot) {
        final startTime = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: EditTimeField(
            time: startTime,
            onChanged: bloc.changeStartTime,
            label: "Startzeit",
          ),
        );
      },
    );
  }
}

class _EndTimeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    return StreamBuilder<Time>(
      stream: bloc.endTime,
      builder: (context, snapshot) {
        final endTime = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: EditTimeField(
            time: endTime,
            onChanged: bloc.changeEndTime,
            label: "Endzeit",
          ),
        );
      },
    );
  }
}

class _RoomField extends StatelessWidget {
  const _RoomField(this.initalLesson, {Key key}) : super(key: key);

  final Lesson initalLesson;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: PrefilledTextField(
          prefilledText: initalLesson.place,
          decoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: const Icon(Icons.place),
            ),
            border: const OutlineInputBorder(),
            labelText: "Raum",
          ),
          maxLength: 32,
          onChanged: bloc.changeRoom,
        ),
      ),
    );
  }
}
