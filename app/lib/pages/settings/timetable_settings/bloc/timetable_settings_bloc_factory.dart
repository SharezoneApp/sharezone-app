// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/pages/settings/timetable_settings/bloc/timetable_settings_bloc.dart';
import 'package:sharezone/pages/settings/timetable_settings/time_picker_settings_cache.dart';
import 'package:sharezone/timetable/src/models/lesson_length/lesson_length_cache.dart';

class TimetableSettingsBlocFactory implements BlocBase {
  final LessonLengthCache lessonLengthCache;
  final TimePickerSettingsCache timetableSettingsCache;

  TimetableSettingsBlocFactory(
      this.lessonLengthCache, this.timetableSettingsCache);

  TimetableSettingsBloc create() {
    return TimetableSettingsBloc(lessonLengthCache, timetableSettingsCache);
  }

  @override
  void dispose() {}
}
