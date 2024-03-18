// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_id.dart';

class GradeDetailsPageControllerFactory {
  GradeDetailsPageController create(SavedGradeId id) {
    return GradeDetailsPageController(id: id);
  }
}
