// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:sharezone_utils/platform.dart';

class MeetingEvent extends AnalyticsEvent {
  MeetingEvent(String name) : super('meeting_$name');

  @override
  Map<String, dynamic> get data => {"platform": getPlatform().toString()};
}