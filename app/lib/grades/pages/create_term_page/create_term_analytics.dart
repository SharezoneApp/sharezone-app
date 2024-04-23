// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class CreateTermAnalytics {
  final Analytics analytics;

  const CreateTermAnalytics(this.analytics);

  void logCreateTerm() {
    analytics.log(NamedAnalyticsEvent(name: 'create_term'));
  }
}
