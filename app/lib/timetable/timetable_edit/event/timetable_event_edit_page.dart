// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event.dart';
import 'package:sharezone/calendrical_events/models/calendrical_event_types.dart';
import 'package:sharezone/markdown/markdown_analytics.dart';
import 'package:sharezone/markdown/markdown_support.dart';
import 'package:sharezone/timetable/src/edit_date.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/timetable_page/lesson/timetable_lesson_sheet.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';

import 'timetable_event_edit_bloc.dart';

void _submit(BuildContext context) {
  final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
  try {
    bloc.submit();
    Navigator.pop(context, true);
  } on Exception catch (e, s) {
    log('$e', error: e, stackTrace: s);

    showSnackSec(text: handleErrorMessage(e.toString(), s), context: context);
  }
}

class TimetableEditEventPage extends StatefulWidget {
  static const tag = "timetable-event-edit-page";

  final TimetableGateway timetableGateway;
  final ConnectionsGateway connectionsGateway;
  final CalendricalEvent initialEvent;

  const TimetableEditEventPage(
    this.initialEvent,
    this.timetableGateway,
    this.connectionsGateway, {
    super.key,
  });

  @override
  State createState() => _TimetableEditEventPageState();
}

class _TimetableEditEventPageState extends State<TimetableEditEventPage> {
  late TimetableEditEventBloc bloc;

  @override
  void initState() {
    final markdownAnalytics = BlocProvider.of<MarkdownAnalytics>(context);
    bloc = TimetableEditEventBloc(
      initialEvent: widget.initialEvent,
      gateway: widget.timetableGateway,
      connectionsGateway: widget.connectionsGateway,
      markdownAnalytics: markdownAnalytics,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: _TimetableEditEventPage(widget.initialEvent),
    );
  }
}

class _TimetableEditEventPage extends StatelessWidget {
  const _TimetableEditEventPage(this.initialEvent);

  final CalendricalEvent initialEvent;

  @override
  Widget build(BuildContext context) {
    final isExam = initialEvent.eventType == Exam();
    return WillPopScope(
      onWillPop: () =>
          warnUserAboutLeavingOrSavingForm(context, () => _submit(context)),
      child: Scaffold(
        backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
        appBar:
            AppBar(title: Text("${isExam ? "Prüfung" : "Termin"} bearbeiten")),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 6),
                _CourseField(initialEvent),
                const Divider(),
                _TitleField(initialEvent),
                const Divider(),
                _DateField(),
                const Divider(),
                _StartTimeField(),
                const Divider(),
                _EndTimeField(),
                const Divider(),
                _SendNotificationField(),
                const Divider(),
                _DetailField(initialEvent),
                const Divider(height: 32),
                _RoomField(initialEvent),
                const Divider(),
              ],
            ),
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
  const _CourseField(this.initialEvent, {Key? key}) : super(key: key);

  final CalendricalEvent initialEvent;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
    final timetableGateway =
        BlocProvider.of<SharezoneContext>(context).api.timetable;
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final isAuthor = api.uID == initialEvent.authorID;
    final hasPermissionsToManageLessons = hasPermissionToManageEvents(
        api.course.getRoleFromCourseNoSync(initialEvent.groupID)!, isAuthor);
    return StreamBuilder<Course>(
      stream: bloc.course,
      builder: (context, snapshot) {
        final course = snapshot.hasData ? snapshot.data : null;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            child: Text(course?.abbreviation ?? ""),
          ),
          title: Text(course?.name ?? ""),
          onTap: () {
            showSnackSec(
              context: context,
              text: "Der Kurs kann nicht mehr nachträglich geändert werden.",
              seconds: 4,
              action: hasPermissionsToManageLessons
                  ? SnackBarAction(
                      label: 'Termin löschen'.toUpperCase(),
                      textColor: Colors.lightBlueAccent,
                      onPressed: () async {
                        final confirmed =
                            await showDeleteLessonConfirmationDialog(context);
                        if (confirmed == true && context.mounted) {
                          timetableGateway.deleteEvent(initialEvent);
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

class _TitleField extends StatelessWidget {
  const _TitleField(this.initialEvent, {Key? key}) : super(key: key);

  final CalendricalEvent initialEvent;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PrefilledTextField(
          prefilledText: initialEvent.title,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Titel",
          ),
          onChanged: bloc.changeTitle,
          maxLength: 36,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
    return StreamBuilder<Date>(
      stream: bloc.date,
      builder: (context, snapshot) {
        final date = snapshot.hasData ? snapshot.data : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: EditDateField(
            date: date,
            onChanged: bloc.changeDate,
            label: "Datum",
          ),
        );
      },
    );
  }
}

class _StartTimeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
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
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
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
  const _RoomField(this.initialEvent, {Key? key}) : super(key: key);

  final CalendricalEvent initialEvent;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PrefilledTextField(
          prefilledText: initialEvent.place,
          decoration: const InputDecoration(
            icon: Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.place),
            ),
            border: OutlineInputBorder(),
            labelText: "Raum",
          ),
          maxLength: 32,
          onChanged: bloc.changeRoom,
        ),
      ),
    );
  }
}

class _SendNotificationField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.sendNotification,
      builder: (context, snapshot) {
        final sendNotification = snapshot.data ?? false;
        return ListTile(
          leading: const Icon(Icons.notifications_active),
          title:
              const Text("Kursmitglieder über die Änderungen benachrichtigen"),
          trailing: Switch.adaptive(
            onChanged: bloc.changeSendNotification,
            value: sendNotification,
          ),
          onTap: () => bloc.changeSendNotification(!sendNotification),
        );
      },
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField(this.initialEvent, {Key? key}) : super(key: key);

  final CalendricalEvent initialEvent;

  @override
  Widget build(BuildContext context) {
    final isExam = initialEvent.eventType == Exam();
    final bloc = BlocProvider.of<TimetableEditEventBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PrefilledTextField(
              prefilledText: initialEvent.detail,
              decoration: InputDecoration(
                icon: const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.details),
                ),
                border: const OutlineInputBorder(),
                labelText: isExam ? "Themen der Prüfung" : "Details",
              ),
              onChanged: bloc.changeDetail,
              textInputAction: TextInputAction.newline,
              maxLines: null,
            ),
            const SizedBox(height: 8),
            const MarkdownSupport(),
          ],
        ),
      ),
    );
  }
}
