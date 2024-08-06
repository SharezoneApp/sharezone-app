// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';

import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_view.dart';

class TermSettingsPageController extends ChangeNotifier {
  final GradesService gradesService;
  final TermRef termRef;
  TermId get termId => termRef.id;
  final Stream<List<Course>> coursesStream;

  late String name;
  late bool isActiveTerm;
  late GradingSystem gradingSystem;
  late GradeType finalGradeType;
  late IMap<GradeTypeId, Weight> _weights;
  IList<Course> courses = IList();
  late StreamSubscription<List<Course>> _courseSubscription;

  TermSettingsState state = const TermSettingsLoading();

  TermSettingsPageView get view => TermSettingsPageView(
        isActiveTerm: isActiveTerm,
        name: name,
        gradingSystem: gradingSystem,
        finalGradeType: finalGradeType,
        selectableGradingTypes: gradesService.getPossibleGradeTypes(),
        weights: _weights,
        subjects: _mergeCoursesAndSubjects(),
      );

  TermSettingsPageController({
    required this.gradesService,
    required this.termRef,
    required this.coursesStream,
  }) {
    final term = _getTerm();
    if (term == null) {
      state = const TermSettingsError('Term not found');
      return;
    }

    name = term.name;
    isActiveTerm = term.isActiveTerm;
    gradingSystem = term.gradingSystem;
    finalGradeType = term.finalGradeType;
    _weights = term.gradeTypeWeightings;

    state = TermSettingsLoaded(view);

    _listenToCourses();
  }

  void _listenToCourses() {
    _courseSubscription = coursesStream.listen((courses) {
      this.courses = courses.toIList();
      state = TermSettingsLoaded(view);
      notifyListeners();
    });
  }

  /// Merges the courses from the group system with the subject from the grades
  /// features.
  IList<SubjectView> _mergeCoursesAndSubjects() {
    final subjects = (_getTerm()?.subjects ?? IList());
    final subjectViews = <SubjectView>[...subjects.toView()];
    for (final course in courses) {
      final matchingSubject = subjectViews
          .firstWhereOrNull((subject) => subject.displayName == course.subject);
      final hasSubjectForThisCourse = matchingSubject != null;
      if (!hasSubjectForThisCourse) {
        final subjectId = SubjectId(course.id);
        subjectViews.add(course.toSubject(subjectId));
      }
    }
    return IList(subjectViews.sortByName());
  }

  TermResult? _getTerm() {
    return gradesService.terms.value.firstWhereOrNull((t) => t.id == termId);
  }

  void setName(String name) {
    this.name = name;
    termRef.changeName(name);
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setIsActiveTerm(bool isActiveTerm) {
    this.isActiveTerm = isActiveTerm;
    termRef.changeActiveTerm(isActiveTerm);
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setGradingSystem(GradingSystem gradingSystem) {
    this.gradingSystem = gradingSystem;
    termRef.changeGradingSystem(gradingSystem);
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setFinalGradeType(GradeType gradeType) {
    termRef.changeFinalGradeType(finalGradeType.id);
    finalGradeType = gradeType;
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setGradeWeight(GradeTypeId gradeTypeId, Weight weight) {
    termRef.changeGradeTypeWeight(gradeTypeId, weight);
    _weights = _weights.add(gradeTypeId, weight);
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void removeGradeType(GradeTypeId gradeTypeId) {
    termRef.removeGradeTypeWeight(gradeTypeId);
    _weights = _weights.remove(gradeTypeId);
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  Future<void> setSubjectWeight(SubjectId subjectId, Weight weight) async {
    final subRef = termRef.subject(subjectId);
    final isNewSubject = gradesService.getSubject(subjectId) == null;
    if (isNewSubject) {
      subjectId = _createSubject(subRef);

      // Firestore had a soft limit of 1 write per second per document. However,
      // this limit isn't mentioned in the documentation anymore. We still keep
      // the delay to be on the safe side.
      //
      // https://stackoverflow.com/questions/74454570/has-firestore-removed-the-soft-limit-of-1-write-per-second-to-a-single-document
      await Future.delayed(const Duration(milliseconds: 500));
    }

    subRef.changeWeightForTermGrade(weight);

    // Wait for Firestore listener to update the subject weights. The view
    // fetches the weights from the grades service. The better solution would be
    // to stream the weights from the grades service to the view.
    await Future.delayed(const Duration(milliseconds: 500));

    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  SubjectId _createSubject(TermSubjectRef subRef) {
    final subject = view.subjects.firstWhere((s) => s.id == subRef.id);
    final connectedCourses = _getConnectedCourses(subRef.id);

    final newSubjectId = gradesService.addSubject(
      SubjectInput(
        design: subject.design,
        name: subject.displayName,
        abbreviation: subject.abbreviation,
        connectedCourses: connectedCourses,
      ),
    );
    return newSubjectId;
  }

  IList<ConnectedCourse> _getConnectedCourses(SubjectId subjectId) {
    final subject = view.subjects.firstWhere((s) => s.id == subjectId);
    return courses
        .where((c) => c.subject == subject.displayName)
        .map(
          (c) => ConnectedCourse(
            id: CourseId(c.id),
            abbreviation: c.abbreviation,
            name: c.name,
            subjectName: c.subject,
          ),
        )
        .toIList();
  }

  @override
  void dispose() {
    _courseSubscription.cancel();
    super.dispose();
  }
}

extension on IList<SubjectResult> {
  IList<SubjectView> toView() {
    return map(
      (s) => (
        id: s.id,
        design: s.design,
        displayName: s.name,
        abbreviation: s.abbreviation,
        weight: s.weightingForTermGrade
      ),
    ).toIList();
  }
}

extension on Course {
  SubjectView toSubject(SubjectId id) {
    return (
      id: id,
      design: getDesign(),
      displayName: subject,
      abbreviation: subject.substring(0, 2),
      weight: const Weight.factor(1),
    );
  }
}

extension on List<SubjectView> {
  List<SubjectView> sortByName() {
    return this..sort((a, b) => a.displayName.compareTo(b.displayName));
  }
}

sealed class TermSettingsState {
  const TermSettingsState();
}

class TermSettingsLoading extends TermSettingsState {
  const TermSettingsLoading();
}

class TermSettingsLoaded extends TermSettingsState {
  final TermSettingsPageView view;

  const TermSettingsLoaded(this.view);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TermSettingsLoaded && other.view == view;
  }

  @override
  int get hashCode => view.hashCode;
}

class TermSettingsError extends TermSettingsState {
  final String message;

  const TermSettingsError(this.message);
}
