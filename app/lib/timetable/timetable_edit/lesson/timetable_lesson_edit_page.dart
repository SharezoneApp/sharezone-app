// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/edit_period.dart';
import 'package:sharezone/timetable/src/edit_time.dart';
import 'package:sharezone/timetable/src/edit_weekday.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/logic/lesson_delete_all_suggestion.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/timetable_page/lesson/timetable_lesson_details.dart';
import 'package:sharezone/timetable/timetable_permissions.dart';
import 'package:sharezone/util/api/connections_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

import 'timetable_lesson_edit_bloc.dart';

void _submit(BuildContext context) {
  final bloc = BlocProvider.of<TimetableEditBloc>(context);
  try {
    bloc.submit();
    Navigator.pop(context, true);
  } on Exception catch (e, s) {
    log('$e', error: e, stackTrace: s);

    showSnackSec(
      text: handleErrorMessage(l10n: context.l10n, error: e, stackTrace: s),
      context: context,
    );
  }
}

class TimetableEditLessonPage extends StatefulWidget {
  static const tag = "timetable-lesson-edit-page";

  final TimetableGateway timetableGateway;
  final ConnectionsGateway connectionsGateway;
  final TimetableBloc timetableBloc;
  final Lesson initialLesson;

  const TimetableEditLessonPage(
    this.initialLesson,
    this.timetableGateway,
    this.connectionsGateway,
    this.timetableBloc, {
    super.key,
  });

  @override
  State createState() => _TimetableEditLessonPageState();
}

class _TimetableEditLessonPageState extends State<TimetableEditLessonPage> {
  late TimetableEditBloc bloc;

  @override
  void initState() {
    bloc = TimetableEditBloc(
      initialLesson: widget.initialLesson,
      gateway: widget.timetableGateway,
      connectionsGateway: widget.connectionsGateway,
      timetableBloc: widget.timetableBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: _TimetableEditPage(widget.initialLesson),
    );
  }
}

class _TimetableEditPage extends StatelessWidget {
  final Lesson initialLesson;

  const _TimetableEditPage(this.initialLesson);

  @override
  Widget build(BuildContext context) {
    final editBloc = BlocProvider.of<TimetableEditBloc>(context);
    final timetableBloc = BlocProvider.of<TimetableBloc>(context);
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final shouldPop = await warnUserAboutLeavingOrSavingForm(
          context,
          () => _submit(context),
        );

        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).isDarkTheme ? null : Colors.white,
        appBar: AppBar(title: Text(context.l10n.timetableEditLessonTitle)),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 6),
              _CourseField(initialLesson),
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
              RoomField(
                onChanged: editBloc.changeRoom,
                initialPlace: initialLesson.place,
              ),
              const Divider(),
              TeacherField(
                onTeacherChanged: editBloc.changeTeacher,
                teachers: timetableBloc.currentTeachers,
                initialTeacher: initialLesson.teacher,
              ),
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
      tooltip: context.l10n.commonActionsSave,
      heroTag: 'sharezone-fab',
      child: const Icon(Icons.done),
      onPressed: () => _submit(context),
    );
  }
}

class _CourseField extends StatelessWidget {
  const _CourseField(this.initialLesson);

  final Lesson initialLesson;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TimetableEditBloc>(context);
    final timetableGateway =
        BlocProvider.of<SharezoneContext>(context).api.timetable;
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final hasPermissionsToManageLessons = hasPermissionToManageLessons(
      api.course.getRoleFromCourseNoSync(initialLesson.groupID)!,
    );
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
              text: context.l10n.timetableEditCourseLocked,
              seconds: 4,
              action:
                  hasPermissionsToManageLessons
                      ? SnackBarAction(
                        label:
                            context.l10n.timetableLessonDetailsDeleteTitle
                                .toUpperCase(),
                        textColor: Colors.lightBlueAccent,
                        onPressed: () async {
                          final confirmed =
                              await showDeleteLessonConfirmationDialog(context);
                          if (confirmed == true && context.mounted) {
                            timetableGateway.deleteLesson(initialLesson);
                            LessonDeleteAllSuggestion.recordLessonDeletion(
                              context,
                            );
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
          leading: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(Icons.today),
          ),
          title: weekDay == null ? null : Text(getWeekDayText(weekDay)),
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
          leading: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(Icons.timeline),
          ),
          title: Text(
            period != null
                ? context.l10n.timetableEditPeriodSelected(period.number)
                : context.l10n.timetableEditNoPeriodSelected,
          ),
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
          leading: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(Icons.swap_horiz),
          ),
          title: weekType == null ? null : Text(getWeekTypeText(weekType)),
          onTap: () async {
            final newWeekType = await selectWeekType(
              context,
              selected: weekType,
            );
            if (newWeekType != null) {
              log("WeekType beim Change: ${getWeekTypeText(weekType!)}");
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
            label: context.l10n.timetableEditStartTime,
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
            label: context.l10n.timetableEditEndTime,
          ),
        );
      },
    );
  }
}

class RoomField extends StatelessWidget {
  const RoomField({super.key, required this.onChanged, this.initialPlace});

  final String? initialPlace;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: const Padding(
          padding: EdgeInsets.only(left: 6, bottom: 26),
          child: Icon(Icons.place),
        ),
        title: PrefilledTextField(
          prefilledText: initialPlace,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: context.l10n.timetableLessonDetailsRoom.trim(),
          ),
          textCapitalization: TextCapitalization.sentences,
          maxLength: 32,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class TeacherField extends StatelessWidget {
  const TeacherField({
    super.key,
    required this.teachers,
    required this.onTeacherChanged,
    this.initialTeacher,
  });

  final String? initialTeacher;
  final ISet<String> teachers;
  final ValueChanged<String> onTeacherChanged;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = Provider.of<SubscriptionService>(
      context,
    ).hasFeatureUnlocked(SharezonePlusFeature.addTeachersToTimetable);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        leading: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: Icon(Icons.person),
        ),
        onTap:
            isUnlocked
                ? null
                : () => showTeachersInTimetablePlusDialog(context),
        title: IgnorePointer(
          key: const Key('teacher-ignore-pointer-widget'),
          ignoring: !isUnlocked,
          child: Autocomplete(
            initialValue: TextEditingValue(text: initialTeacher ?? ''),
            optionsBuilder: (textEditingValue) {
              return teachers
                  .where(
                    (teacher) => teacher.toLowerCase().contains(
                      textEditingValue.text.toLowerCase().trim(),
                    ),
                  )
                  .toList();
            },
            fieldViewBuilder: (
              context,
              textEditingController,
              focusNode,
              onFieldSubmitted,
            ) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.l10n.timetableLessonDetailsTeacher.trim(),
                  hintText: context.l10n.timetableEditTeacherHint,
                  suffixIcon:
                      isUnlocked
                          ? null
                          : const Padding(
                            padding: EdgeInsets.fromLTRB(4, 4, 12, 4),
                            child: SharezonePlusChip(),
                          ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: onTeacherChanged,
              );
            },
            onSelected: onTeacherChanged,
          ),
        ),
      ),
    );
  }
}
