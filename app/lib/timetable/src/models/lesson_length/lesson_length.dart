// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

class LessonLength {
  final int minutes;
  bool get isValid => minutes > 0;
  Duration get duration => Duration(minutes: minutes);

  LessonLength(this.minutes);
  LessonLength.standard() : minutes = 45;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LessonLength && other.minutes == minutes;
  }

  @override
  int get hashCode => minutes.hashCode;
}
