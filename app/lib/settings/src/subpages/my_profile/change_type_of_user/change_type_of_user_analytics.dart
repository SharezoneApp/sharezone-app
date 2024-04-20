// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserAnalytics {
  final Analytics analytics;

  const ChangeTypeOfUserAnalytics(this.analytics);

  void logChangedOrder({
    required TypeOfUser? from,
    required TypeOfUser to,
  }) {
    analytics.log(
      ChangeOfTypeOfUserAnalyticsEvent(
        data: {
          'from': from?.name,
          'to': to.name,
        },
      ),
    );
  }
}

class ChangeOfTypeOfUserAnalyticsEvent extends AnalyticsEvent {
  const ChangeOfTypeOfUserAnalyticsEvent({
    Map<String, dynamic>? data,
  }) : super('changed_type_of_user', data: data);
}
