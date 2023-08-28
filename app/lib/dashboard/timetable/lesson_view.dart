// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:design/design.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';

enum LessonTimeStatus { hasAlreadyTakenPlace, isNow, isYetToCome }

class LessonView {
  final String start, end, abbreviation;
  final String? room, periodNumber;
  final Design design;
  final Lesson lesson;

  final LessonTimeStatus timeStatus;

  /// Gibt an, wie viel Prozent (0.0 - 1.0) der Stunde schon vorbei ist.
  final double percentTimePassed;

  LessonView({
    required this.start,
    required this.end,
    required this.room,
    required this.abbreviation,
    required this.design,
    required this.lesson,
    required this.timeStatus,
    required this.percentTimePassed,
    required this.periodNumber,
  });
}
