// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';

class GradesDialogControllerFactory {
  final CrashAnalytics crashAnalytics;
  final GradesService gradesService;
  final Analytics analytics;

  /// Returns a stream of courses.
  ///
  /// We use a function to create the stream because we want to create a new
  /// stream every time we create a new controller. Otherwise, we would get an
  /// error because the stream is already closed when opening the dialog a
  /// second time.
  final Stream<List<Course>> Function() coursesStream;

  const GradesDialogControllerFactory({
    required this.crashAnalytics,
    required this.gradesService,
    required this.coursesStream,
    required this.analytics,
  });

  GradesDialogController create(GradeId? gradeId) {
    return GradesDialogController(
      coursesStream: coursesStream(),
      crashAnalytics: crashAnalytics,
      gradesService: gradesService,
      analytics: analytics,
      gradeId: gradeId,
    );
  }
}
