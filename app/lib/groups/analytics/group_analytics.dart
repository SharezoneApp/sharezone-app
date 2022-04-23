// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class GroupAnalytics extends BlocBase {
  final Analytics _analytics;

  GroupAnalytics(this._analytics);

  void logEnableMeeting() {
    _analytics.log(GroupSettingsEvent('enable_meeting'));
  }
  
  void logDisbaleMeeting() {
    _analytics.log(GroupSettingsEvent('disable_meeting'));
  }

  @override
  void dispose() {}
}

class GroupEvent extends AnalyticsEvent {
  GroupEvent(String name) : super('group_$name');
}

class GroupSettingsEvent extends GroupEvent {
  GroupSettingsEvent(String name) : super('settings_$name');
}