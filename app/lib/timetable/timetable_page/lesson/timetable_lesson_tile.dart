// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/timetable/src/models/substitution.dart';

import 'timetable_lesson_details.dart';

class TimetableEntryLesson extends StatelessWidget {
  final Lesson lesson;
  final GroupInfo? groupInfo;
  final Date date;

  const TimetableEntryLesson({
    super.key,
    required this.lesson,
    required this.date,
    this.groupInfo,
  });

  @override
  Widget build(BuildContext context) {
    final canceledDesign = Design.fromColor(Colors.grey[600]!);
    final substitution = lesson.getSubstitutionFor(date);
    final isCanceled = substitution is LessonCanceledSubstitution;
    final design = isCanceled ? canceledDesign : groupInfo?.design;
    final newLocation = substitution is LocationChangedSubstitution
        ? substitution.newLocation
        : null;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: design?.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          onTap: () => showLessonModelSheet(
            context,
            lesson,
            date,
            groupInfo?.design,
          ),
          onLongPress: () => onLessonLongPress(context, lesson),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GroupName(
                      abbreviation: groupInfo?.abbreviation,
                      groupName: groupInfo?.name ?? "",
                      color: design?.color,
                      isStrikeThrough: isCanceled,
                    ),
                    Row(
                      children: [
                        if (lesson.place != null)
                          Room(
                            room: lesson.place!,
                            color: design?.color,
                            isStrikeThrough: isCanceled || newLocation != null,
                          ),
                        if (lesson.place != null && newLocation != null)
                          const SizedBox(width: 4),
                        if (newLocation != null)
                          Room(
                            room: newLocation,
                            color: design?.color,
                            isStrikeThrough: isCanceled,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isCanceled)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _StrikeThroughPainter(
                      color: design?.color,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrikeThroughPainter extends CustomPainter {
  final Color? color;

  _StrikeThroughPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GroupName extends StatelessWidget {
  const GroupName({
    super.key,
    required this.groupName,
    required this.abbreviation,
    required this.color,
    this.isStrikeThrough = false,
  });

  final String groupName;
  final String? abbreviation;
  final Color? color;
  final bool isStrikeThrough;

  String getAbbreviationOrGroupName() {
    if (abbreviation == "") return groupName;
    if (abbreviation == null) return groupName;
    return abbreviation!;
  }

  @override
  Widget build(BuildContext context) {
    final showAbbreviation =
        BlocProvider.of<TimetableBloc>(context).current.showAbbreviation();
    final text = showAbbreviation ? getAbbreviationOrGroupName() : groupName;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Text(
        text,
        key: ValueKey(text),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          decoration: isStrikeThrough ? TextDecoration.lineThrough : null,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class Room extends StatelessWidget {
  const Room({
    super.key,
    required this.room,
    this.isStrikeThrough = false,
    this.color,
  });

  final String room;
  final Color? color;
  final bool isStrikeThrough;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        room,
        style: TextStyle(
          color: color,
          fontSize: 12,
          decoration: isStrikeThrough ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
