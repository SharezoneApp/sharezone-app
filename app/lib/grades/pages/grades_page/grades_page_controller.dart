// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_view.dart';

class GradesPageController extends ChangeNotifier {
  GradesPageState state = const GradesPageLoading();
  StreamSubscription? _subscription;

  final GradesService gradesService;

  GradesPageController({
    required this.gradesService,
  }) {
    _subscription = gradesService.terms.listen((event) {
      try {
        final activeTerm = event.firstWhereOrNull((term) => term.isActiveTerm);
        CurrentTermView? currentTerm;

        if (activeTerm != null) {
          final subjectGrades = activeTerm.subjects
              .expand<SubjectView>((subject) => subject.grades.map((grade) => (
                    id: subject.id,
                    abbreviation: subject.abbreviation,
                    displayName: subject.name,
                    grade: displayGrade(grade.value),
                    design: subject.design,
                  )))
              .toIList();

          currentTerm = (
            id: activeTerm.id,
            avgGrade: (
              displayGrade(activeTerm.calculatedGrade),
              GradePerformance.good,
            ),
            subjects: subjectGrades.toList(),
            displayName: activeTerm.name,
          );
        }

        final pastTerm = event.where((term) => !term.isActiveTerm).toList();
        final pastTermViews = <PastTermView>[];
        for (final term in pastTerm) {
          pastTermViews.add(
            (
              id: term.id,
              avgGrade: (
                displayGrade(term.calculatedGrade),
                GradePerformance.good
              ),
              displayName: term.name,
            ),
          );
        }
        pastTermViews.sortByTermName();

        currentTerm?.subjects.sortByDisplayName();

        state = GradesPageLoaded(
          currentTerm: currentTerm,
          pastTerms: pastTermViews,
        );
        notifyListeners();
      } catch (e) {
        state = GradesPageError('$e');
        notifyListeners();
      }
    }, onError: (e) {
      state = GradesPageError('$e');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// This is not covered by tests yet.
String displayGrade(GradeValue? grade) {
  if (grade == null) return '—';
  if (!grade.gradingSystem.isNumericalAndContinous) {
    return grade.displayableGrade ?? '—';
  }

  String withSuffix(String gs) => '$gs${grade.suffix ?? ''}';

  if (grade.displayableGrade != null) return grade.displayableGrade!;
  if (!grade.asNum.hasDecimals) return withSuffix('${grade.asNum}');
  // Only show two decimals: "2.23563" -> "2.23"
  var gradeString = grade.asDouble.toStringAsFixedWithoutRounding(2);
  return withSuffix(gradeString);
}

extension on double {
  String toStringAsFixedWithoutRounding(int fractionDigits) {
    // toStringAsFixed rounds the number, so we add one more digit and then remove it
    final s = toStringAsFixed(fractionDigits + 1);
    return s.substring(0, s.length - 1);
  }
}

extension on List<PastTermView> {
  /// Sorts the terms by their [displayName].
  ///
  /// "Q1/2"
  /// "Q1/1"
  /// "10/2"
  /// "10/1"
  /// "9/2"
  /// "9/1"
  void sortByTermName() {
    // todo(nilsreichardt): this doesn't work because with Strings is "9" > "10"
    sort((a, b) => b.displayName.compareTo(a.displayName));
  }
}

extension on List<SubjectView> {
  void sortByDisplayName() {
    sort((a, b) => a.displayName.compareTo(b.displayName));
  }
}

sealed class GradesPageState {
  const GradesPageState();
}

class GradesPageLoading extends GradesPageState {
  const GradesPageLoading();
}

class GradesPageLoaded extends GradesPageState {
  /// The current term.
  ///
  /// If the user hasn't selected a current term, this will be `null`.
  final CurrentTermView? currentTerm;

  /// The past terms.
  ///
  /// If the user has no past terms, this will be an empty list.
  final List<PastTermView> pastTerms;

  const GradesPageLoaded({
    required this.currentTerm,
    required this.pastTerms,
  });

  /// Returns `true` if the user has any grades in any term.
  bool hasGrades() {
    return !(currentTerm == null && pastTerms.isEmpty);
  }
}

class GradesPageError extends GradesPageState {
  final String error;

  const GradesPageError(this.error);
}
