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
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart';

class GradeDetailsPageControllerFactory {
  final GradesService gradesService;
  final CrashAnalytics crashAnalytics;
  final Analytics analytics;

  const GradeDetailsPageControllerFactory({
    required this.gradesService,
    required this.crashAnalytics,
    required this.analytics,
  });

  GradeDetailsPageController create(GradeId id) {
    return GradeDetailsPageController(
      id: id,
      gradesService: gradesService,
      crashAnalytics: crashAnalytics,
      analytics: analytics,
    );
  }
}
