// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller.dart';

class TermDetailsPageControllerFactory {
  final GradesService gradesService;
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;

  const TermDetailsPageControllerFactory({
    required this.gradesService,
    required this.crashAnalytics,
    required this.analytics,
  });

  // TODO Change TermId to TermRef
  TermDetailsPageController create(TermId termId) {
    return TermDetailsPageController(
      termRef: gradesService.term(termId),
      gradesService: gradesService,
      crashAnalytics: crashAnalytics,
      analytics: analytics,
    );
  }
}
