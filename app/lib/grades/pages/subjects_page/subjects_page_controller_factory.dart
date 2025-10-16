// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller.dart';

class SubjectsPageControllerFactory {
  final GradesService gradesService;
  final Stream<List<Course>> Function() coursesStream;

  const SubjectsPageControllerFactory({
    required this.gradesService,
    required this.coursesStream,
  });

  SubjectsPageController create() {
    return SubjectsPageController(
      gradesService: gradesService,
      coursesStream: coursesStream(),
    );
  }
}
