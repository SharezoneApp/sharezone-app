import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharezone/grades/grade_views.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';

class TermsRepository {
  Stream<Term> getTerm(TermId id) {
    throw UnimplementedError();
  }

  Stream<List<Term>> getAllTerms() {
    throw UnimplementedError();
  }
}

class Term {
  final TermId id;
  final String displayName;
  final TermGrade grade;
  final List<Subject> subjects;

  factory Term({
    required this.id,
    required this.displayName,
    required this.grade,
    required this.subjects,
  }) {
    //berechnen...


    return Term()
  }
}

class TermGrade {
  final double grade;

  const TermGrade({required this.grade});
}

class Subject {
  final SubjectId id;
  final SubjectName name;
  final Design design;
  final SubjectGrade calculatedGrade;
  final List<SavedGrade> grades;
}

class SubjectName {
  final String value;
  final String abbreviation;
}

class SubjectGrade {}

class SavedGrade {
  final String title;
  final Date receivedOn;
  final GradeValue value;
}

class GradeValue {}

class GradeType {
  final GradeIcon icon;
  final String displayName;
}

enum GradeIcon {
  note_add,
  text_format;

  Icon toIcon() {
    return switch (this) {
      GradeIcon.note_add => const Icon(Icons.note_add),
      GradeIcon.text_format => const Icon(Icons.text_format),
    };
  }
}
