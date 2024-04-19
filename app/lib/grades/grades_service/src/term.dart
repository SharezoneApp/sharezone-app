// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../grades_service.dart';

@visibleForTesting
class TermModel {
  final TermId id;
  final IList<SubjectModel> subjects;
  final IMap<GradeTypeId, double> gradeTypeWeightings;
  final GradingSystemModel gradingSystem;
  final GradeTypeId finalGradeType;
  final bool isActiveTerm;
  final String name;

  TermModel({
    required this.id,
    required this.finalGradeType,
    required this.gradingSystem,
    required this.isActiveTerm,
    required this.name,
  })  : subjects = const IListConst([]),
        gradeTypeWeightings = const IMapConst({});

  TermModel.internal(
    this.id,
    this.subjects,
    this.gradeTypeWeightings,
    this.finalGradeType,
    this.isActiveTerm,
    this.name,
    this.gradingSystem,
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
        term: this,
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

  TermModel _copyWith({
    TermId? id,
    IList<SubjectModel>? subjects,
    IMap<GradeTypeId, double>? gradeTypeWeightings,
    GradeTypeId? finalGradeType,
    bool? isActiveTerm,
    String? name,
    GradingSystemModel? gradingSystem,
  }) {
    return TermModel.internal(
      id ?? this.id,
      subjects ?? this.subjects,
      gradeTypeWeightings ?? this.gradeTypeWeightings,
      finalGradeType ?? this.finalGradeType,
      isActiveTerm ?? this.isActiveTerm,
      name ?? this.name,
      gradingSystem ?? this.gradingSystem,
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
            .map((subject) => subject.gradeVal! * subject.weightingForTermGrade)
            .reduce(
              (a, b) => a + b,
            ) /
        gradedSubjects
            .map((e) => e.weightingForTermGrade)
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
      {required num weight}) {
    final newWeights = gradeTypeWeightings.add(type, weight.toDouble());
    final newSubjects = subjects.map((s) {
      final newSubject = s.copyWith(gradeTypeWeightingsFromTerm: newWeights);
      return newSubject;
    }).toIList();

    return _copyWith(subjects: newSubjects, gradeTypeWeightings: newWeights);
  }

  TermModel setFinalGradeType(GradeTypeId gradeType) {
    final newSubjects =
        subjects.where((s) => s.isFinalGradeTypeOverridden == false).map((s) {
      final newSubject = s.copyWith(finalGradeType: gradeType);
      return newSubject;
    }).toIList();

    return _copyWith(finalGradeType: gradeType, subjects: newSubjects);
  }

  TermModel addGrade(Grade grade, {required SubjectId toSubject}) {
    var subject = subjects.firstWhere(
      (s) => s.id == toSubject,
      orElse: () => throw SubjectNotFoundException(toSubject),
    );

    final gradingSystem = grade.gradingSystem.toGradingSystemModel();
    final gradeVal = gradingSystem.toNumOrThrow(grade.value);

    subject = subject.addGrade(GradeModel(
      term: this,
      id: grade.id,
      date: grade.date,
      value: gradingSystem.toGradeResult(gradeVal),
      gradingSystem: gradingSystem,
      takenIntoAccount: grade.takeIntoAccount,
      gradeType: grade.type,
      weight: 1,
      title: grade.title,
      details: grade.details,
    ));

    return subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: subjects.add(subject));
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

  bool hasGrade(GradeId gradeId) {
    return subjects.any((s) => s.hasGrade(gradeId));
  }

  TermModel changeWeighting(SubjectId id, num newWeight) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightingForTermGrade: newWeight,
    );

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel changeWeightingOfGradeTypeInSubject(
      SubjectId id, GradeTypeId gradeType, double weight) {
    final subject = subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.changeGradeTypeWeight(gradeType, weight: weight);

    return _copyWith(
      subjects: subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  TermModel changeWeightOfGrade(
      GradeId id, SubjectId subjectId, double weight) {
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
}

@visibleForTesting
class SubjectModel {
  final TermModel term;
  final SubjectId id;
  final String name;
  final GradingSystemModel gradingSystem;
  final IList<GradeModel> grades;
  final GradeTypeId finalGradeType;
  final bool isFinalGradeTypeOverridden;
  final num weightingForTermGrade;
  final IMap<GradeTypeId, double> gradeTypeWeightings;
  final IMap<GradeTypeId, double> gradeTypeWeightingsFromTerm;
  final WeightType weightType;
  final String abbreviation;
  final Design design;
  final IList<ConnectedCourse> connectedCourses;

  late final num? gradeVal;

  SubjectModel({
    required this.term,
    required this.id,
    required this.name,
    required this.weightType,
    required this.gradingSystem,
    required this.finalGradeType,
    required this.abbreviation,
    required this.design,
    this.connectedCourses = const IListConst([]),
    this.isFinalGradeTypeOverridden = false,
    this.grades = const IListConst([]),
    this.weightingForTermGrade = 1,
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
            .map((grade) => grade.value.asNum * _weightFor(grade))
            .reduce((a, b) => a + b) /
        grds.map((e) => _weightFor(e)).reduce((a, b) => a + b);
  }

  num _weightFor(GradeModel grade) {
    return switch (weightType) {
      WeightType.perGrade => grade.weight,
      WeightType.perGradeType => gradeTypeWeightings[grade.gradeType] ?? 1,
      WeightType.inheritFromTerm =>
        gradeTypeWeightingsFromTerm[grade.gradeType] ?? 1,
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
      {required double weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  SubjectModel overrideFinalGradeType(GradeTypeId gradeType) {
    return copyWith(
        finalGradeType: gradeType, isFinalGradeTypeOverridden: true);
  }

  GradeModel grade(GradeId id) {
    return grades.firstWhere((element) => element.id == id);
  }

  SubjectModel copyWith({
    TermModel? term,
    SubjectId? id,
    String? name,
    String? abbreviation,
    Design? design,
    IList<GradeModel>? grades,
    GradeTypeId? finalGradeType,
    bool? isFinalGradeTypeOverridden,
    num? weightingForTermGrade,
    GradingSystemModel? gradingSystem,
    IMap<GradeTypeId, double>? gradeTypeWeightings,
    IMap<GradeTypeId, double>? gradeTypeWeightingsFromTerm,
    WeightType? weightType,
    IList<ConnectedCourse>? connectedCourses,
  }) {
    return SubjectModel(
      term: term ?? this.term,
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
    );
  }
}

@visibleForTesting
class GradeModel extends Equatable {
  final TermModel term;
  final GradeId id;
  final GradeValue value;
  final GradingSystemModel gradingSystem;
  final GradeTypeId gradeType;
  final bool takenIntoAccount;
  final num weight;
  final Date date;
  final String title;
  final String? details;

  @override
  List<Object?> get props => [
        id,
        value,
        gradingSystem,
        gradeType,
        takenIntoAccount,
        weight,
        title,
        details,
      ];

  const GradeModel({
    required this.term,
    required this.id,
    required this.value,
    required this.gradeType,
    required this.gradingSystem,
    required this.weight,
    required this.date,
    required this.takenIntoAccount,
    required this.title,
    required this.details,
  });

  GradeModel changeWeight(double weight) {
    return copyWith(weight: weight, takenIntoAccount: weight > 0);
  }

  GradeModel copyWith({
    TermModel? term,
    GradeId? id,
    GradeValue? value,
    Date? date,
    GradingSystemModel? gradingSystem,
    GradeTypeId? gradeType,
    bool? takenIntoAccount,
    num? weight,
    String? title,
    String? details,
  }) {
    return GradeModel(
      term: term ?? this.term,
      id: id ?? this.id,
      value: value ?? this.value,
      date: date ?? this.date,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      gradeType: gradeType ?? this.gradeType,
      takenIntoAccount: takenIntoAccount ?? this.takenIntoAccount,
      weight: weight ?? this.weight,
      title: title ?? this.title,
      details: details ?? this.details,
    );
  }
}
