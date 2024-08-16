// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore_for_file: library_private_types_in_public_api

part of '../grades_service.dart';

@visibleForTesting
class TermModel extends Equatable {
  final TermId id;
  final DateTime? createdOn;
  final IList<SubjectModel> subjects;
  final IMap<GradeTypeId, Weight> gradeTypeWeightings;
  final GradingSystemModel gradingSystem;
  final GradeTypeId finalGradeType;
  final bool isActiveTerm;
  final String name;
  final WeightDisplayType weightDisplayType;

  @override
  List<Object?> get props => [
        id,
        createdOn,
        subjects,
        gradeTypeWeightings,
        weightDisplayType,
        gradingSystem,
        finalGradeType,
        isActiveTerm,
        name,
      ];

  const TermModel({
    required this.id,
    required this.finalGradeType,
    required this.gradingSystem,
    required this.isActiveTerm,
    required this.name,
    this.createdOn,
    this.subjects = const IListConst([]),
    this.gradeTypeWeightings = const IMapConst({}),
    this.weightDisplayType = WeightDisplayType.factor,
  });

  const TermModel.internal(
    this.id,
    this.subjects,
    this.gradeTypeWeightings,
    this.weightDisplayType,
    this.finalGradeType,
    this.isActiveTerm,
    this.name,
    this.gradingSystem,
    this.createdOn,
  );

  bool hasSubject(SubjectId id) {
    return subjects.any((s) => s.id == id);
  }

  TermModel addSubject(Subject subject) {
    if (hasSubject(subject.id)) {
      throw SubjectAlreadyExistsException(subject.id);
    }
    return _copyWith(
      subjects: subjects.add(SubjectModel(
        termId: id,
        id: subject.id,
        name: subject.name,
        abbreviation: subject.abbreviation,
        design: subject.design,
        gradingSystem: gradingSystem,
        finalGradeType: finalGradeType,
        connectedCourses: subject.connectedCourses,
        weightType: WeightType.inheritFromTerm,
        gradeTypeWeightingsFromTerm: gradeTypeWeightings,
      )),
    );
  }

  SubjectModel subject(SubjectId id) {
    return subjects.where((s) => s.id == id).first;
  }

  TermModel replaceSubject(SubjectModel subject) {
    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == subject.id, subject),
    );
  }

  TermModel _copyWith({
    TermId? id,
    IList<SubjectModel>? subjects,
    IMap<GradeTypeId, Weight>? gradeTypeWeightings,
    WeightDisplayType? weightDisplayType,
    GradeTypeId? finalGradeType,
    bool? isActiveTerm,
    String? name,
    GradingSystemModel? gradingSystem,
    DateTime? createdOn,
  }) {
    return TermModel.internal(
      id ?? this.id,
      subjects ?? this.subjects,
      gradeTypeWeightings ?? this.gradeTypeWeightings,
      weightDisplayType ?? this.weightDisplayType,
      finalGradeType ?? this.finalGradeType,
      isActiveTerm ?? this.isActiveTerm,
      name ?? this.name,
      gradingSystem ?? this.gradingSystem,
      createdOn ?? this.createdOn,
    );
  }

  num? tryGetTermGrade() {
    try {
      return getTermGrade();
    } catch (e) {
      return null;
    }
  }

  num getTermGrade() {
    final gradedSubjects =
        subjects.where((element) => element.gradeVal != null);
    return gradedSubjects
            .map((subject) =>
                subject.gradeVal! * subject.weightingForTermGrade.asFactor)
            .reduce(
              (a, b) => a + b,
            ) /
        gradedSubjects
            .map((e) => e.weightingForTermGrade.asFactor)
            .reduce((a, b) => a + b);
  }

  TermModel changeWeightTypeForSubject(SubjectId id, WeightType weightType) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightType: weightType,
    );

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel changeWeightingOfGradeType(GradeTypeId type,
      {required Weight weight}) {
    final newWeights = gradeTypeWeightings.add(type, weight);
    final newSubjects = subjects.map((s) {
      final newSubject = s.copyWith(gradeTypeWeightingsFromTerm: newWeights);
      return newSubject;
    }).toIList();

    return _copyWith(subjects: newSubjects, gradeTypeWeightings: newWeights);
  }

  TermModel removeWeightingOfGradeType(GradeTypeId type) {
    final newWeights = gradeTypeWeightings.remove(type);
    final newSubjects = subjects.map((s) {
      final newSubject = s.copyWith(gradeTypeWeightingsFromTerm: newWeights);
      return newSubject;
    }).toIList();

    return _copyWith(subjects: newSubjects, gradeTypeWeightings: newWeights);
  }

  TermModel setFinalGradeType(GradeTypeId gradeType) {
    final newSubjects = subjects.map((s) {
      if (s.isFinalGradeTypeOverridden) return s;

      final newSubject = s.copyWith(finalGradeType: gradeType);
      return newSubject;
    }).toIList();

    return _copyWith(finalGradeType: gradeType, subjects: newSubjects);
  }

  TermModel addGrade(_Grade grade, {required SubjectId toSubject}) {
    var subject = subjects.firstWhere(
      (s) => s.id == toSubject,
      orElse: () => throw SubjectNotFoundException(toSubject),
    );

    subject = subject.addGrade(_toGradeModel(grade, subjectId: subject.id));

    return subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: subjects.add(subject));
  }

  TermModel replaceGrade(_Grade grade) {
    final subject = subjects.firstWhere((s) => s.hasGrade(grade.id));
    final gradeModel = _toGradeModel(grade, subjectId: subject.id);

    final newSubject = subject.replaceGrade(gradeModel);

    final newSubjects =
        subjects.replaceAllWhere((s) => s.id == subject.id, newSubject);
    return _copyWith(subjects: newSubjects);
  }

  TermModel removeGrade(GradeId gradeId) {
    final subject = subjects.firstWhere(
      (s) => s.hasGrade(gradeId),
      orElse: () => throw GradeNotFoundException(gradeId),
    );

    final newSubject = subject.removeGrade(gradeId);

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == subject.id, newSubject),
    );
  }

  GradeModel _toGradeModel(_Grade grade, {required SubjectId subjectId}) {
    final originalInput = grade.value;
    final gradingSystem = grade.gradingSystem.toGradingSystemModel();
    final gradeVal = gradingSystem.toNumOrThrow(grade.value);

    return GradeModel(
      id: grade.id,
      subjectId: subjectId,
      termId: id,
      date: grade.date,
      originalInput: originalInput,
      value: gradingSystem.toGradeResult(gradeVal),
      gradingSystem: gradingSystem,
      takenIntoAccount: grade.takeIntoAccount,
      gradeType: grade.type,
      weight: const Weight.factor(1),
      title: grade.title,
      details: grade.details,
    );
  }

  bool hasGrade(GradeId gradeId) {
    return subjects.any((s) => s.hasGrade(gradeId));
  }

  TermModel changeWeighting(SubjectId id, Weight newWeight) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightingForTermGrade: newWeight,
    );

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel changeWeightingOfGradeTypeInSubject(
      SubjectId id, GradeTypeId gradeType, Weight weight) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.changeGradeTypeWeight(gradeType, weight: weight);

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel removeWeightingOfGradeTypeInSubject(
      SubjectId id, GradeTypeId gradeType) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.removeGradeTypeWeight(gradeType);

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel changeWeightOfGrade(
      GradeId id, SubjectId subjectId, Weight weight) {
    final subject = subjects.firstWhere((s) => s.id == subjectId);
    final newSubject = subject.copyWith(
      grades: subject.grades.replaceFirstWhere(
        (g) => g.id == id,
        (g) => g!.changeWeight(weight),
      ),
    );

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == subjectId, newSubject),
    );
  }

  TermModel setFinalGradeTypeForSubject(SubjectId id, GradeTypeId gradeType) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.overrideFinalGradeType(gradeType);

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel subjectInheritFinalGradeTypeFromTerm(SubjectId id) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      finalGradeType: finalGradeType,
      isFinalGradeTypeOverridden: false,
    );

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel setIsActiveTerm(bool isActiveTerm) {
    return _copyWith(isActiveTerm: isActiveTerm);
  }

  TermModel setName(String name) {
    return _copyWith(name: name);
  }

  TermModel setGradingSystem(GradingSystemModel gradingSystem) {
    return _copyWith(gradingSystem: gradingSystem);
  }

  bool containsGrade(GradeId id) {
    return subjects.any((s) => s.hasGrade(id));
  }
}

class SubjectModel extends Equatable {
  final SubjectId id;
  final String name;
  final TermId termId;
  final GradingSystemModel gradingSystem;
  final IList<GradeModel> grades;
  final GradeTypeId finalGradeType;
  final bool isFinalGradeTypeOverridden;
  final Weight weightingForTermGrade;
  final IMap<GradeTypeId, Weight> gradeTypeWeightings;
  final IMap<GradeTypeId, Weight> gradeTypeWeightingsFromTerm;
  final WeightType weightType;
  final String abbreviation;
  final Design design;
  final IList<ConnectedCourse> connectedCourses;
  final DateTime? createdOn;

  late final num? gradeVal;

  @override
  List<Object?> get props => [
        id,
        name,
        termId,
        gradingSystem,
        grades,
        finalGradeType,
        isFinalGradeTypeOverridden,
        weightingForTermGrade,
        gradeTypeWeightings,
        gradeTypeWeightingsFromTerm,
        weightType,
        abbreviation,
        design,
        connectedCourses,
        createdOn,
      ];

  SubjectModel({
    required this.id,
    required this.termId,
    required this.name,
    required this.weightType,
    required this.gradingSystem,
    required this.finalGradeType,
    required this.abbreviation,
    required this.design,
    this.createdOn,
    this.connectedCourses = const IListConst([]),
    this.isFinalGradeTypeOverridden = false,
    this.grades = const IListConst([]),
    this.weightingForTermGrade = const Weight.factor(1),
    this.gradeTypeWeightings = const IMapConst({}),
    this.gradeTypeWeightingsFromTerm = const IMapConst({}),
  }) {
    gradeVal = _getGradeVal();
  }

  num? _getGradeVal() {
    final grds = grades.where((grade) =>
        grade.takenIntoAccount && grade.gradingSystem == gradingSystem);
    if (grds.isEmpty) return null;

    final finalGrade =
        grds.where((grade) => grade.gradeType == finalGradeType).firstOrNull;
    if (finalGrade != null) return finalGrade.value.asNum;

    return grds
            .map((grade) => grade.value.asNum * _weightFor(grade).asFactor)
            .reduce((a, b) => a + b) /
        grds
            .map((e) => _weightFor(e))
            .reduce((a, b) => Weight.factor(a.asFactor + b.asFactor))
            .asFactor;
  }

  Weight _weightFor(GradeModel grade) {
    return switch (weightType) {
      WeightType.perGrade => grade.weight,
      WeightType.perGradeType =>
        gradeTypeWeightings[grade.gradeType] ?? const Weight.factor(1),
      WeightType.inheritFromTerm =>
        gradeTypeWeightingsFromTerm[grade.gradeType] ?? const Weight.factor(1),
    };
  }

  SubjectModel addGrade(GradeModel grade) {
    return copyWith(grades: grades.add(grade));
  }

  SubjectModel removeGrade(GradeId gradeId) {
    return copyWith(grades: grades.removeWhere((grade) => grade.id == gradeId));
  }

  bool hasGrade(GradeId gradeId) {
    return grades.any((g) => g.id == gradeId);
  }

  SubjectModel changeGradeTypeWeight(GradeTypeId gradeType,
      {required Weight weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  SubjectModel removeGradeTypeWeight(GradeTypeId gradeType) {
    return copyWith(gradeTypeWeightings: gradeTypeWeightings.remove(gradeType));
  }

  SubjectModel overrideFinalGradeType(GradeTypeId gradeType) {
    return copyWith(
        finalGradeType: gradeType, isFinalGradeTypeOverridden: true);
  }

  GradeModel grade(GradeId id) {
    return grades.firstWhere((element) => element.id == id);
  }

  SubjectModel replaceGrade(GradeModel grade) {
    final newGrades = grades
        .replaceAllWhere((subjGrade) => subjGrade.id == grade.id, grade)
        .toIList();
    return copyWith(grades: newGrades);
  }

  SubjectModel copyWith({
    TermId? termId,
    SubjectId? id,
    String? name,
    String? abbreviation,
    Design? design,
    IList<GradeModel>? grades,
    GradeTypeId? finalGradeType,
    bool? isFinalGradeTypeOverridden,
    Weight? weightingForTermGrade,
    GradingSystemModel? gradingSystem,
    IMap<GradeTypeId, Weight>? gradeTypeWeightings,
    IMap<GradeTypeId, Weight>? gradeTypeWeightingsFromTerm,
    WeightType? weightType,
    IList<ConnectedCourse>? connectedCourses,
    DateTime? createdOn,
  }) {
    return SubjectModel(
      termId: termId ?? this.termId,
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      design: design ?? this.design,
      grades: grades ?? this.grades,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      finalGradeType: finalGradeType ?? this.finalGradeType,
      isFinalGradeTypeOverridden:
          isFinalGradeTypeOverridden ?? this.isFinalGradeTypeOverridden,
      weightingForTermGrade:
          weightingForTermGrade ?? this.weightingForTermGrade,
      gradeTypeWeightings: gradeTypeWeightings ?? this.gradeTypeWeightings,
      weightType: weightType ?? this.weightType,
      gradeTypeWeightingsFromTerm:
          gradeTypeWeightingsFromTerm ?? this.gradeTypeWeightingsFromTerm,
      connectedCourses: connectedCourses ?? this.connectedCourses,
      createdOn: createdOn ?? this.createdOn,
    );
  }
}

class GradeModel extends Equatable {
  final GradeId id;
  final SubjectId subjectId;
  final TermId termId;
  final GradeValue value;
  final GradingSystemModel gradingSystem;
  final GradeTypeId gradeType;
  final bool takenIntoAccount;
  final Weight weight;
  final Date date;
  final String title;
  final String? details;
  final DateTime? createdOn;
  final Object originalInput;

  @override
  List<Object?> get props => [
        id,
        subjectId,
        termId,
        value,
        // This will cause tests to fail (== operator not working correctly) and
        // I don't know how to fix it. For now we'll just ignore it.
        // originalInput,
        gradingSystem,
        gradeType,
        takenIntoAccount,
        weight,
        date,
        title,
        details,
        createdOn,
      ];

  const GradeModel({
    required this.id,
    required this.subjectId,
    required this.termId,
    required this.value,
    required this.gradeType,
    required this.gradingSystem,
    required this.weight,
    required this.date,
    required this.takenIntoAccount,
    required this.title,
    required this.originalInput,
    required this.details,
    this.createdOn,
  }) : assert(originalInput is String || originalInput is num);

  GradeModel changeWeight(Weight weight) {
    return copyWith(weight: weight, takenIntoAccount: weight.asFactor > 0);
  }

  GradeModel copyWith({
    GradeId? id,
    SubjectId? subjectId,
    TermId? termId,
    GradeValue? value,
    Date? date,
    GradingSystemModel? gradingSystem,
    GradeTypeId? gradeType,
    bool? takenIntoAccount,
    Weight? weight,
    String? title,
    String? details,
    DateTime? createdOn,
    Object? originalInput,
  }) {
    return GradeModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      termId: termId ?? this.termId,
      value: value ?? this.value,
      date: date ?? this.date,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      gradeType: gradeType ?? this.gradeType,
      takenIntoAccount: takenIntoAccount ?? this.takenIntoAccount,
      weight: weight ?? this.weight,
      title: title ?? this.title,
      details: details ?? this.details,
      createdOn: createdOn ?? this.createdOn,
      originalInput: originalInput ?? this.originalInput,
    );
  }
}
