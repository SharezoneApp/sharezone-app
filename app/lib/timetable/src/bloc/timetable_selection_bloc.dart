// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:date/date.dart';
import 'package:date/weektype.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';
import 'package:user/user.dart';

class EmptyPeriodSelection {
  final Date date;
  final Period period;
  final WeekType weekType;

  EmptyPeriodSelection({
    required this.date,
    required this.period,
    required this.weekType,
  });

  @override
  bool operator ==(other) {
    return other is EmptyPeriodSelection &&
        period == other.period &&
        weekType == other.weekType &&
        date == other.date;
  }

  @override
  int get hashCode => hash3(date.hashCode, period.hashCode, weekType.hashCode);
}

class TimetableSelectionBloc extends BlocBase {
  final _emptyPeriodSelectionSubject =
      BehaviorSubject<EmptyPeriodSelection?>.seeded(null);

  Stream<EmptyPeriodSelection?> get emptyPeriodSelections =>
      _emptyPeriodSelectionSubject;

  void onTapSelection(EmptyPeriodSelection selection) {
    _emptyPeriodSelectionSubject.sink.add(selection);
  }

  void clearSelections() {
    _emptyPeriodSelectionSubject.sink.add(null);
  }

  void createLesson(
    TimetableGateway gateway,
    EmptyPeriodSelection emptyPeriodSelection,
    Course course,
  ) {
    final lesson = Lesson(
      // The 'createdOn' field will be added in the gateway because we use
      // serverTimestamp().
      createdOn: null,
      weekday: emptyPeriodSelection.date.weekDayEnum,
      weektype: emptyPeriodSelection.weekType,
      startTime: emptyPeriodSelection.period.startTime,
      endTime: emptyPeriodSelection.period.endTime,
      groupID: course.id,
      groupType: GroupType.course,
      lessonID: null,
      place: null,
      teacher: null,
      periodNumber: emptyPeriodSelection.period.number,
    );
    gateway.createLesson(lesson);
    clearSelections();
  }

  @override
  void dispose() {
    _emptyPeriodSelectionSubject.close();
  }
}
