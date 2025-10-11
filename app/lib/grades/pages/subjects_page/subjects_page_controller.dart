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

import 'subjects_page_view.dart';

sealed class SubjectsPageState {
  const SubjectsPageState();
}

class SubjectsPageLoading extends SubjectsPageState {
  const SubjectsPageLoading();
}

class SubjectsPageError extends SubjectsPageState {
  final String message;

  const SubjectsPageError(this.message);
}

class SubjectsPageLoaded extends SubjectsPageState {
  final SubjectsPageView view;

  const SubjectsPageLoaded(this.view);
}

class SubjectsPageController extends ChangeNotifier {
  final GradesService gradesService;
  final Stream<List<Course>> coursesStream;

  SubjectsPageState state = const SubjectsPageLoading();

  late final StreamSubscription<IList<TermResult>> _termsSubscription;
  StreamSubscription<List<Course>>? _coursesSubscription;

  IList<TermResult> _terms = const IListConst([]);
  IList<Course> _courses = const IListConst([]);

  SubjectsPageController({
    required this.gradesService,
    required this.coursesStream,
  }) {
    _terms = gradesService.terms.value;
    _updateView();
    _listenToTerms();
    _listenToCourses();
  }

  void _listenToTerms() {
    _termsSubscription = gradesService.terms.listen(
      (terms) {
        _terms = terms;
        _updateView();
      },
      onError: (error, stackTrace) {
        _setError('$error');
      },
    );
  }

  void _listenToCourses() {
    _coursesSubscription = coursesStream.listen(
      (courses) {
        _courses = IList(courses);
        _updateView();
      },
      onError: (error, stackTrace) {
        _setError('$error');
      },
    );
  }

  void _setError(String message) {
    state = SubjectsPageError(message);
    notifyListeners();
  }

  void _updateView() {
    try {
      final view = _buildView();
      state = SubjectsPageLoaded(view);
      notifyListeners();
    } catch (error) {
      _setError('$error');
    }
  }

  SubjectsPageView _buildView() {
    final gradeSubjects = gradesService.getSubjects();
    final gradeTypes = gradesService.getPossibleGradeTypes();
    final gradeTypeNames = gradeTypes.fold<Map<GradeTypeId, String>>(
      {},
      (acc, gradeType) {
        final name =
            gradeType.displayName ??
            gradeType.predefinedType?.toUiString() ??
            'Unbekannt';
        acc[gradeType.id] = name;
        return acc;
      },
    );

    final gradeSubjectNames = gradeSubjects.map((s) => s.name).toSet();

    final gradeSubjectItems =
        gradeSubjects
            .map(
              (subject) => _toItemView(
                subject: subject,
                canDelete: true,
                gradeTypeNames: gradeTypeNames,
              ),
            )
            .toIList();

    final coursesWithoutSubject =
        _courses
            .where((course) => !gradeSubjectNames.contains(course.subject))
            .groupListsBy((course) => course.subject)
            .entries
            .map(
              (entry) => _toCourseItemView(
                subjectName: entry.key,
                courses: entry.value,
              ),
            )
            .toIList();

    return SubjectsPageView(
      gradeSubjects: gradeSubjectItems,
      coursesWithoutSubject: coursesWithoutSubject,
    );
  }

  SubjectListItemView _toItemView({
    required Subject subject,
    required bool canDelete,
    required Map<GradeTypeId, String> gradeTypeNames,
  }) {
    final grades = <SubjectGradeView>[];

    for (final term in _terms) {
      final termSubject = term.subjects.firstWhereOrNull(
        (element) => element.id == subject.id,
      );
      if (termSubject == null) continue;

      for (final grade in termSubject.grades) {
        grades.add(
          SubjectGradeView(
            id: grade.id,
            title: grade.title,
            displayValue: _formatGradeValue(grade.value),
            termName: term.name,
            date: grade.date,
            gradeTypeName: gradeTypeNames[grade.gradeTypeId] ?? 'Unbekannt',
          ),
        );
      }
    }

    return SubjectListItemView(
      id: subject.id,
      name: subject.name,
      abbreviation: subject.abbreviation,
      design: subject.design,
      connectedCourses: subject.connectedCourses,
      canDelete: canDelete,
      grades: IList(grades),
    );
  }

  SubjectListItemView _toCourseItemView({
    required String subjectName,
    required List<Course> courses,
  }) {
    final firstCourse = courses.first;
    final connectedCourses =
        courses
            .map(
              (course) => ConnectedCourse(
                id: CourseId(course.id),
                name: course.name,
                abbreviation: course.abbreviation,
                subjectName: course.subject,
              ),
            )
            .toIList();

    return SubjectListItemView(
      id: SubjectId('course-${firstCourse.id}'),
      name: subjectName,
      abbreviation: firstCourse.abbreviation,
      design: firstCourse.getDesign(),
      connectedCourses: connectedCourses,
      canDelete: false,
      grades: const IListConst([]),
    );
  }

  Future<void> deleteSubject(SubjectId id) async {
    gradesService.deleteSubject(id);
  }

  @override
  void dispose() {
    _termsSubscription.cancel();
    _coursesSubscription?.cancel();
    super.dispose();
  }
}

String _formatGradeValue(GradeValue value) {
  if (!value.gradingSystem.isNumericalAndContinous) {
    return value.displayableGrade ?? '—';
  }

  if (value.displayableGrade != null) {
    return value.displayableGrade!;
  }

  final suffix = value.suffix ?? '';
  if (!value.asNum.hasDecimals) {
    return '${value.asNum}$suffix';
  }

  final gradeString = value.asDouble.toStringAsFixedWithoutRounding(2);
  return '$gradeString$suffix';
}

extension on double {
  String toStringAsFixedWithoutRounding(int fractionDigits) {
    final s = toStringAsFixed(fractionDigits + 1);
    return s.substring(0, s.length - 1);
  }
}
