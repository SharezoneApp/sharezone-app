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

  Future<void> createTerm() async {
    gradesService.createTerm(
      id: TermId(termName),
      gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
      name: termName,
      finalGradeType: const GradeTypeId('foo'),
      isActiveTerm: true,
    );
    return;
  }
}
