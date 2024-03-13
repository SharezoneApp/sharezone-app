// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/models/subject_id.dart';

enum GradePerformance {
  good,
  satisfactory,
  bad;

  Color toColor() {
    return switch (this) {
      GradePerformance.good => Colors.green,
      GradePerformance.satisfactory => Colors.orange,
      GradePerformance.bad => Colors.red,
    };
  }
}

typedef Abbreviation = String;
typedef DisplayName = String;
typedef GradeView = String;
typedef SubjectView = ({
  SubjectId id,
  Abbreviation abbreviation,
  DisplayName displayName,
  Design design,
  GradeView grade,
});

typedef AvgGradeView = (GradeView, GradePerformance);
typedef CurrentTermView = ({
  TermId id,
  DisplayName displayName,
  AvgGradeView avgGrade,
  List<SubjectView> subjects
});
typedef PastTermView = ({
  TermId id,
  DisplayName displayName,
  AvgGradeView avgGrade
});
