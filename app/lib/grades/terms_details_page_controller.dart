import 'dart:async';
import 'dart:math';

import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grade_views.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:sharezone/grades/terms_repository.dart';

class TermsDetailsPageController extends ChangeNotifier {
  late TermDetailsPageState state;
  final TermId termId;
  final TermsRepository repository = TermsRepository();

  StreamSubscription<Term>? _subscription;

  TermsDetailsPageController({required this.termId}) {
    final random = Random(42);

    final termStream = repository.getTerm(termId);
    _subscription = termStream.listen((term) {
      final subjects = term.subjects;
      final grades = subjects.grades(SubjectId(''));
    }, onError: (error) {
      state = TermDetailsPageError('$error');
      notifyListeners();
    });

    state = TermDetailsPageLoaded(
      term: (
        id: TermId('term-1'),
        displayName: '10/2',
        avgGrade: ('1,0', GradePerformance.good),
      ),
      subjectsWithGrades: [
        (
          grades: [
            (
              gradeTypeIcon: const Icon(Icons.note_add),
              date: Date.fromDateTime(DateTime(2021, 2, 2)),
              grade: '1,0',
              gradeTypeName: 'Klausur',
            ),
            (
              gradeTypeIcon: const Icon(Icons.text_format),
              date: Date.fromDateTime(DateTime(2021, 2, 1)),
              grade: '2+',
              gradeTypeName: 'Vokabeltest',
            ),
          ],
          subject: (
            displayName: 'Deutsch',
            abbreviation: 'DE',
            grade: '2,0',
            design: Design.random(random),
            id: SubjectId('1'),
          ),
        ),
        (
          grades: [],
          subject: (
            displayName: 'Englisch',
            abbreviation: 'E',
            grade: '2+',
            design: Design.random(random),
            id: SubjectId('2'),
          ),
        ),
        (
          grades: [],
          subject: (
            displayName: 'Mathe',
            abbreviation: 'DE',
            grade: '1-',
            design: Design.random(random),
            id: SubjectId('3'),
          ),
        ),
      ],
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

sealed class TermDetailsPageState {
  const TermDetailsPageState();
}

class TermDetailsPageLoading extends TermDetailsPageState {
  const TermDetailsPageLoading();
}

typedef SavedGradeView = ({
  GradeView grade,
  Icon gradeTypeIcon,
  String gradeTypeName,
  Date date,
});

class TermDetailsPageLoaded extends TermDetailsPageState {
  final PastTermView term;
  final List<({SubjectView subject, List<SavedGradeView> grades})>
      subjectsWithGrades;

  const TermDetailsPageLoaded({
    required this.term,
    required this.subjectsWithGrades,
  });
}

class TermDetailsPageError extends TermDetailsPageState {
  final String error;

  const TermDetailsPageError(this.error);
}
