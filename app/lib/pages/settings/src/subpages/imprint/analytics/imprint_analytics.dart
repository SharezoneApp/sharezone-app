// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class ImprintAnalytics extends BlocBase {
  final Analytics _analytics;

  ImprintAnalytics(this._analytics);

  void logOpenImprint() {
    _analytics.log(NamedAnalyticsEvent(name: 'open_imprint'));
  }

  @override
  void dispose() {}
}
