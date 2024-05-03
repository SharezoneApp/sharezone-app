// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/foundation.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class TermDialogController extends ChangeNotifier {
  final GradesService gradesService;
  TermDialogController(this.gradesService);

  String termName = '';

  void setTermName(String value) {
    termName = value;
    notifyListeners();
  }

  GradingSystem gradingSystem = GradingSystem.oneToSixWithPlusAndMinus;

  void setGradingSystem(GradingSystem value) {
    gradingSystem = value;
    notifyListeners();
  }

  Future<void> addTerm() async {
    gradesService.addTerm(
      id: TermId(termName),
      gradingSystem: gradingSystem,
      name: termName,
      finalGradeType: GradeType.schoolReportGrade.id,
      isActiveTerm: true,
    );
    return;
  }
}
