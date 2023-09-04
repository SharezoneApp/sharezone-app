// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/pages/settings/timetable_settings/time_picker_settings_cache.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';

class TimetableSettingsBloc extends BlocBase {
  TimetableSettingsBloc(this.lessonLengthCache, this._timePickerSettingsCache)
      : lessonLengthStream = lessonLengthCache.streamLessonLength(),
        isTimePickerFifeMinutesIntervalActive = _timePickerSettingsCache
            .isTimePickerWithFifeMinutesIntervalActiveStream();

  final LessonLengthCache lessonLengthCache;
  final TimePickerSettingsCache _timePickerSettingsCache;
  final Stream<LessonLength> lessonLengthStream;

  final Stream<bool> isTimePickerFifeMinutesIntervalActive;

  Function(LessonLength) get changeLessonLength =>
      lessonLengthCache.setLessonLength;

  void saveLessonLengthInCache(int? lengthInMinutes) {
    if (lengthInMinutes != null) {
      final lessonLength = LessonLength(lengthInMinutes);
      lessonLengthCache.setLessonLength(lessonLength);
    }
  }

  void setIsTimePickerFifeMinutesIntervalActive(bool newValue) {
    _timePickerSettingsCache.setTimePickerWithFifeMinutesInterval(newValue);
  }

  @override
  void dispose() {} // Required by BlocProvider
}
