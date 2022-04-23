// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';

class SchoolClassFilterAnalytics {
  final Analytics _analytics;

  SchoolClassFilterAnalytics(this._analytics);

  void logFilterBySchoolClass() {
    _analytics.log(const SchoolClassFilterEvent('show_a_specific_class'));
  }

  /// Loggt, dass der Nutzer "Alle" auswählt, so dass alle Termine und Termine
  /// angezeigt werden.
  void logShowAllGroups() {
    _analytics.log(const SchoolClassFilterEvent('show_all_groups'));
  }
}

class SchoolClassFilterEvent extends AnalyticsEvent {
  const SchoolClassFilterEvent(String name)
      : super('school_class_filter_$name');
}
