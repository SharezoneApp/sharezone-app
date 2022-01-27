// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

import 'meeting_event.dart';

class MeetingAnalytics {
  final Analytics _analytics;

  MeetingAnalytics(this._analytics);

  void logJoinedGroupMeeting() {
    _analytics.log(MeetingEvent('group_joined'));
  }
}
