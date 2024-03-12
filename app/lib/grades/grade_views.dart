import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:sharezone/grades/subject_id.dart';

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
