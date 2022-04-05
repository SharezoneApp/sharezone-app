// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:date/weekday.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/settings/src/bloc/user_settings_bloc.dart';
import 'package:user/user.dart';

class EnabledWeekDaysEditBloc extends BlocBase {
  final UserSettingsBloc _userSettingsBloc;
  final _weekDaysSubject = BehaviorSubject<EnabledWeekDays>();

  EnabledWeekDaysEditBloc(this._userSettingsBloc) {
    _changeEnabledWeekDays(_userSettingsBloc.current().enabledWeekDays);
  }

  Stream<EnabledWeekDays> get weekDays => _weekDaysSubject;

  Function(EnabledWeekDays) get _changeEnabledWeekDays =>
      _weekDaysSubject.sink.add;

  Future<void> submit() async {
    final weekDays = _weekDaysSubject.valueOrNull;
    _userSettingsBloc.updateEnabledWeekDays(weekDays);
  }

  Future<void> changeWeekDay(WeekDay weekDay, bool newValue) async {
    final weekDays = _weekDaysSubject.valueOrNull;
    await _changeEnabledWeekDays(weekDays.copyWith(weekDay, newValue));
  }

  @override
  void dispose() {
    _weekDaysSubject.close();
  }
}
