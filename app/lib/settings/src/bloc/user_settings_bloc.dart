// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

class UserSettingsBloc extends BlocBase {
  final UserGateway _userGateway;

  UserSettingsBloc(this._userGateway);

  Stream<UserSettings> streamUserSettings() {
    return _userGateway.userStream.map((user) => user.userSettings);
  }

  UserSettings? current() => _userGateway.data?.userSettings;

  void updateSettings(UserSettings newUserSettings) {
    _userGateway.updateSettings(newUserSettings);
  }

  void updatePeriods(Periods periods) {
    _userGateway.updateSettingsSingleFiled('periods', periods.toJson());
  }

  void updateEnabledWeekDays(EnabledWeekDays? enabledWeekDays) {
    _userGateway.updateSettingsSingleFiled(
        'enabledWeekDays', enabledWeekDays?.toJson());
  }

  void updateTimetableStartTime(Time time) {
    _userGateway.updateSettingsSingleFiled(
        'timetableStartTime', time.toString());
  }

  @override
  void dispose() {}
}
