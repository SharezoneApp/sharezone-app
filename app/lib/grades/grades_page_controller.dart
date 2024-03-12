import 'dart:async';
import 'dart:math';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grade_views.dart';
import 'package:sharezone/grades/term_id.dart';

import 'subject_id.dart';

class GradesPageController extends ChangeNotifier {
  GradesPageState state = const GradesPageLoading();
  StreamSubscription? _subscription;

  GradesPageController() {
    final random = Random(42);
    var gradesPageLoaded = GradesPageLoaded(
      currentTerm: (
        id: TermId('term-0'),
        displayName: '11/1',
        avgGrade: ('1,4', GradePerformance.good),
        subjects: [
          (
            displayName: 'Deutsch',
            abbreviation: 'DE',
            grade: '2,0',
            design: Design.random(random),
            id: SubjectId('1'),
          ),
          (
            displayName: 'Englisch',
            abbreviation: 'E',
            grade: '2+',
            design: Design.random(random),
            id: SubjectId('2'),
          ),
          (
            displayName: 'Mathe',
            abbreviation: 'DE',
            grade: '1-',
            design: Design.random(random),
            id: SubjectId('3'),
          ),
          (
            displayName: 'Sport',
            abbreviation: 'DE',
            grade: '1,0',
            design: Design.random(random),
            id: SubjectId('4'),
          ),
          (
            displayName: 'Physik',
            abbreviation: 'PH',
            grade: '3,0',
            design: Design.random(random),
            id: SubjectId('5'),
          ),
        ]
      ),
      pastTerms: [
        (
          id: TermId('term-1'),
          displayName: '10/2',
          avgGrade: ('1,0', GradePerformance.good),
        ),
        (
          id: TermId('term-2'),
          displayName: '10/1',
          avgGrade: ('2,4', GradePerformance.satisfactory),
        ),
        (
          id: TermId('term-3'),
          displayName: '9/2',
          avgGrade: ('1,0', GradePerformance.good),
        ),
        (
          id: TermId('term-4'),
          displayName: '9/1',
          avgGrade: ('3,7', GradePerformance.bad),
        ),
        (
          id: TermId('term-5'),
          displayName: '8/2',
          avgGrade: ('1,7', GradePerformance.good),
        ),
      ],
    );
    state = gradesPageLoaded;
    notifyListeners();
    // _subscription = Stream.value(
    //   gradesPageLoaded,
    // ).listen((event) {
    //   state = event;
    // }, onError: (error) {
    //   state = GradesPageError(error.toString());
    //   notifyListeners();
    // });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

sealed class GradesPageState {
  const GradesPageState();
}

class GradesPageLoading extends GradesPageState {
  const GradesPageLoading();
}

class GradesPageLoaded extends GradesPageState {
  final CurrentTermView currentTerm;
  final List<PastTermView> pastTerms;

  const GradesPageLoaded({
    required this.currentTerm,
    required this.pastTerms,
  });
}

class GradesPageError extends GradesPageState {
  final String error;

  const GradesPageError(this.error);
}
