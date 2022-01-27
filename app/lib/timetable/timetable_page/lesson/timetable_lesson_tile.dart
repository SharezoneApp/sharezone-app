// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';

import 'timetable_lesson_sheet.dart';

class TimetableEntryLesson extends StatelessWidget {
  final String date;
  final Lesson lesson;
  final GroupInfo groupInfo;

  const TimetableEntryLesson({this.date, this.lesson, this.groupInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: groupInfo?.design?.color?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(top: 3, left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GroupName(
                    abbreviation: groupInfo?.abbreviation,
                    groupName: groupInfo?.name,
                    color: groupInfo?.design?.color),
                if (lesson.place != null)
                  Room(
                    room: lesson.place,
                    color: groupInfo?.design?.color,
                  ),
              ],
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          onTap: () => showLessonModelSheet(context, lesson, groupInfo.design),
          onLongPress: () => onLessonLongPress(context, lesson),
        ),
      ),
    );
  }
}

class GroupName extends StatelessWidget {
  const GroupName(
      {Key key,
      @required this.groupName,
      @required this.abbreviation,
      @required this.color})
      : super(key: key);

  final String groupName;
  final String abbreviation;
  final Color color;

  String getAbbreviationOrGroupName() {
    if (abbreviation == "") return groupName;
    if (abbreviation == null) return groupName;
    return abbreviation;
  }

  @override
  Widget build(BuildContext context) {
    final showAbbreviation =
        BlocProvider.of<TimetableBloc>(context).current.showAbbreviation();
    final text =
        (showAbbreviation ? getAbbreviationOrGroupName() : groupName) ?? '';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Text(
        text,
        key: ValueKey(text),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class Room extends StatelessWidget {
  const Room({
    Key key,
    @required this.room,
    @required this.color,
  }) : super(key: key);

  final String room;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        room,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
