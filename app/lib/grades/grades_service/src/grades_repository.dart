// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore_for_file: library_private_types_in_public_api

part of '../grades_service.dart';

typedef GradesState = ({
  IList<Term> terms,
  IList<GradeType> customGradeTypes,
  IList<Subject> subjects
});

extension GradesStateCopyWith on GradesState {
  GradesState copyWith({
    IList<Term>? terms,
    IList<GradeType>? customGradeTypes,
    IList<Subject>? subjects,
  }) {
    return (
      terms: terms ?? this.terms,
      customGradeTypes: customGradeTypes ?? this.customGradeTypes,
      subjects: subjects ?? this.subjects,
    );
  }
}

abstract class GradesStateRepository {
  BehaviorSubject<GradesState> get state;
  void updateState(GradesState state);
}

class InMemoryGradesStateRepository extends GradesStateRepository {
  @override
  BehaviorSubject<GradesState> state = BehaviorSubject<GradesState>();

  InMemoryGradesStateRepository() {
    state.add((
      terms: const IListConst([]),
      customGradeTypes: const IListConst([]),
      subjects: const IListConst([]),
    ));
  }

  @override
  void updateState(GradesState state) {
    this.state.add(state);
  }
}

class FirestoreGradesStateRepository extends GradesStateRepository {
  // final FirebaseFirestore _firestore;
  // final DocumentReference _userDocumentRef;
  // DocumentReference get gradesDocumentRef =>
  //     _userDocumentRef.collection('grades').doc('0');

  // FirestoreGradesRepository(this._firestore, this._userDocumentRef);
  Map<String, Object> _data = {};

  @override
  BehaviorSubject<GradesState> state = BehaviorSubject<GradesState>.seeded(
    (
      terms: const IListConst([]),
      customGradeTypes: const IListConst([]),
      subjects: const IListConst([]),
    ),
  );

  @override
  void updateState(GradesState state) {
    // gradesDocumentRef.set(_toDto(state), SetOptions(merge: true));
    _data = toDto(state);
    // debugPrint(json.encode(_data, toEncodable: (val) {
    //   if (val is Timestamp) {
    //     return val.toDate().toIso8601String();
    //   }
    // }));
    this.state.add(fromData(_data));
  }

  static Map<String, Object> toDto(GradesState state) {
    final currentTermOrNull =
        state.terms.firstWhereOrNull((term) => term.isActiveTerm)?.id.id;
    return {
      if (currentTermOrNull != null) 'currentTerm': currentTermOrNull,
      'terms': state.terms
          .map((term) => MapEntry(term.id.id, TermDto.fromTerm(term).toData()))
          .toMap(),
      'grades': state.terms
          .expand((term) => term.subjects.expand((p0) => p0.grades))
          .map((g) => MapEntry(g.id.id, GradeDto.fromGrade(g).toData()))
          .toMap(),
      'customGradeTypes': state.customGradeTypes
          .map((element) => MapEntry(element.id.id,
              CustomGradeTypeDto.fromGradeType(element).toData()))
          .toMap(),
      'subjects': state.subjects
          .map((subject) =>
              MapEntry(subject.id.id, SubjectDto.fromSubject(subject).toData()))
          .toMap()
    };
  }

  static GradesState fromData(Map<String, Object?> data) {
    IList<TermDto> termDtos = const IListConst([]);

    if (data case {'terms': Map<String, Map<String, Object?>> termData}) {
      termDtos =
          termData.mapTo((value, key) => TermDto.fromData(key)).toIList();
    }

    IList<SubjectDto> subjectDtos = const IListConst([]);
    if (data case {'subjects': Map<String, Map<String, Object?>> subjectData}) {
      subjectDtos =
          subjectData.mapTo((value, key) => SubjectDto.fromData(key)).toIList();
    }

    IList<GradeDto> gradeDtos = const IListConst([]);
    if (data case {'grades': Map<String, Map<String, Object?>> gradeData}) {
      gradeDtos =
          gradeData.mapTo((value, key) => GradeDto.fromData(key)).toIList();
    }

    IList<CustomGradeTypeDto> customGradeTypeDtos = const IListConst([]);
    if (data
        case {
          'customGradeTypes': Map<String, Map<String, Object?>> gradeTypeData
        }) {
      customGradeTypeDtos = gradeTypeData
          .mapTo((value, key) => CustomGradeTypeDto.fromData(key))
          .toIList();
    }

    final grades = gradeDtos.map(
      (dto) {
        final gradingSystem = dto.gradingSystem.toGradingSystem();
        return GradeModel(
          id: GradeId(dto.id),
          termId: TermId(dto.termId),
          date: dto.receivedAt.toDate().toDate(),
          gradingSystem: gradingSystem,
          gradeType: GradeTypeId(dto.gradeType),
          subjectId: SubjectId(dto.subjectId),
          takenIntoAccount: dto.includeInGrading,
          title: dto.title,
          details: dto.details,
          value: gradingSystem.toGradeResult(dto.numValue),
          weight: termDtos
                  .firstWhereOrNull((element) => element.id == dto.termId)
                  ?.subjects
                  .firstWhereOrNull((element) => element.id == dto.subjectId)
                  ?.gradeComposition
                  .gradeWeights
                  .map((key, value) =>
                      MapEntry(key, value.toWeight()))[dto.id] ??
              const Weight.factor(1),
        );
      },
    ).toIList();

    final subjects = subjectDtos.map(
      (dto) {
        return Subject(
          id: SubjectId(dto.id),
          design: dto.design,
          name: dto.name,
          abbreviation: dto.abbreviation,
          connectedCourses: dto.connectedCourses
              .map((cc) => cc.toConnectedCourse())
              .toIList(),
        );
      },
    ).toIList();

    final allTermSubjects = termDtos
        .expand((term) => term.subjects
            .map((subject) => (termSubject: subject, termId: term.id)))
        .toIList();

    final combinedTermSubjects = allTermSubjects
        .map((termSub) {
          final subject = subjects.firstWhereOrNull(
              (subject) => subject.id.id == termSub.termSubject.id);
          if (subject == null) {
            log('No subject found for the term subject id ${termSub.termSubject.id}.');
            return null;
          }
          return (subject: subject, termSubjectObj: termSub);
        })
        .whereNotNull()
        .toIList();

    final termSubjects = combinedTermSubjects.map((s) {
      var (:subject, :termSubjectObj) = s;
      var (:termSubject, :termId) = termSubjectObj;

      final subTerm = termDtos.firstWhere(
          (term) => term.subjects.any((sub) => sub.id == subject.id.id));
      return SubjectModel(
        id: subject.id,
        termId: TermId(subTerm.id),
        name: subject.name,
        connectedCourses: subject.connectedCourses,
        isFinalGradeTypeOverridden:
            termSubject.finalGradeType != subTerm.finalGradeTypeId,
        gradeTypeWeightings: subTerm.gradeTypeWeights
            .map((key, value) => MapEntry(GradeTypeId(key), value.toWeight()))
            .toIMap(),
        gradeTypeWeightingsFromTerm: subTerm.gradeTypeWeights
            .map((key, value) => MapEntry(GradeTypeId(key), value.toWeight()))
            .toIMap(),
        weightingForTermGrade:
            subTerm.subjectWeights[subject.id.id]?.toWeight() ??
                const Weight.factor(1),
        grades: grades
            .where((grade) =>
                grade.subjectId == subject.id && grade.termId.id == termId)
            .toIList(),
        weightType: termSubject.weightType,
        gradingSystem: subTerm.gradingSystem.toGradingSystem(),
        finalGradeType: GradeTypeId(termSubject.finalGradeType),
        abbreviation: subject.abbreviation,
        design: subject.design,
      );
    }).toIList();

    var terms = termDtos
        .map(
          (dto) => Term(
            id: TermId(dto.id),
            finalGradeType: GradeTypeId(dto.finalGradeTypeId),
            gradingSystem: dto.gradingSystem.toGradingSystem(),
            isActiveTerm: data['currentTerm'] == dto.id,
            subjects: termSubjects
                .where((subject) => subject.termId.id == dto.id)
                .toIList(),
            name: dto.displayName,
            // Change both to num
            gradeTypeWeightings: dto.gradeTypeWeights
                .map((key, value) =>
                    MapEntry(GradeTypeId(key), value.toWeight()))
                .toIMap(),
          ),
        )
        .toIList();

    final customGradeTypes = customGradeTypeDtos
        .map((dto) => GradeType(
              id: GradeTypeId(dto.id),
              displayName: dto.displayName,
            ))
        .toIList();

    return (
      terms: terms,
      customGradeTypes: customGradeTypes,
      subjects: subjects,
    );
  }
}

extension ToMap<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map<K, V>.fromEntries(this);
}

extension on Weight {
  WeightDto toDto() => WeightDto.fromWeight(this);
}

extension on Object? {
  Map<String, WeightDto> toWeightsDtoMap() => _toWeightsDto(this);
}

extension on Map<String, WeightDto> {
  Map<String, Map<String, Object>> toWeightDataMap() =>
      map((key, value) => MapEntry(key, value.toData()));
}

enum _WeightNumberType { factor, percent }

typedef _TermId = String;
typedef _SubjectId = String;
typedef _GradeId = String;
typedef _GradeTypeId = String;

Map<String, WeightDto> _toWeightsDto(Object? data) {
  return (data as Map<String, Map<String, Object?>>)
      .map((key, value) => MapEntry(key, WeightDto.fromData(value)));
}

class WeightDto {
  final num value;
  final _WeightNumberType type;

  WeightDto({
    required this.value,
    required this.type,
  });

  factory WeightDto.fromWeight(Weight weight) {
    return WeightDto(
      value: weight.asFactor,
      type: _WeightNumberType.factor,
    );
  }

  factory WeightDto.fromData(Map<String, Object?> data) {
    return WeightDto(
      value: data['value'] as num,
      type: _WeightNumberType.values.byName(data['type'] as String),
    );
  }

  Weight toWeight() {
    return switch (type) {
      _WeightNumberType.factor => Weight.factor(value),
      _WeightNumberType.percent => Weight.percent(value),
    };
  }

  Map<String, Object> toData() {
    return {
      'value': value,
      'type': type.name,
    };
  }
}

class CustomGradeTypeDto {
  final _GradeTypeId id;
  final String displayName;

  CustomGradeTypeDto({
    required this.id,
    required this.displayName,
  });

  factory CustomGradeTypeDto.fromData(Map<String, Object?> data) {
    return CustomGradeTypeDto(
      id: data['id'] as String,
      displayName: data['displayName'] as String,
    );
  }

  factory CustomGradeTypeDto.fromGradeType(GradeType gradeType) {
    return CustomGradeTypeDto(
      id: gradeType.id.id,
      displayName: gradeType.displayName!,
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'displayName': displayName,
    };
  }
}

class TermDto {
  final _TermId id;
  final String displayName;
  final GradingSystem gradingSystem;
  final Map<_SubjectId, WeightDto> subjectWeights;
  final Map<_GradeTypeId, WeightDto> gradeTypeWeights;
  final List<TermSubjectDto> subjects;
  final _GradeTypeId finalGradeTypeId;

  TermDto({
    required this.id,
    required this.displayName,
    required this.gradingSystem,
    required this.subjectWeights,
    required this.gradeTypeWeights,
    required this.finalGradeTypeId,
    required this.subjects,
  });

  factory TermDto.fromTerm(Term term) {
    return TermDto(
      id: term.id.id,
      displayName: term.name,
      finalGradeTypeId: term.finalGradeType.id,
      gradingSystem: term.gradingSystem.spec.gradingSystem,
      subjects: term.subjects.map(TermSubjectDto.fromSubject).toList(),
      subjectWeights: Map.fromEntries(term.subjects.map((subject) =>
          MapEntry(subject.id.id, subject.weightingForTermGrade.toDto()))),
      gradeTypeWeights: term.gradeTypeWeightings
          .map((gradeId, weight) => MapEntry(gradeId.id, weight.toDto()))
          .unlock,
    );
  }

  factory TermDto.fromData(Map<String, Object?> data) {
    return TermDto(
      id: data['id'] as String,
      displayName: data['displayName'] as String,
      gradingSystem: GradingSystem.fromString(data['gradingSystem'] as String),
      subjectWeights: data['subjectWeights'].toWeightsDtoMap(),
      gradeTypeWeights: data['gradeTypeWeights'].toWeightsDtoMap(),
      subjects: (data['subjects'] as Map<String, Map<String, Object>>)
          .mapTo((_, sub) => TermSubjectDto.fromData(sub))
          .toList(),
      finalGradeTypeId: data['finalGradeType'] as String,
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'displayName': displayName,
      'gradingSystem': gradingSystem.name,
      'subjectWeights': subjectWeights.toWeightDataMap(),
      'gradeTypeWeights': gradeTypeWeights.toWeightDataMap(),
      'subjects': subjects
          .map((subject) => MapEntry(subject.id, subject.toData()))
          .toMap(),
      'finalGradeType': finalGradeTypeId,
    };
  }
}

class TermSubjectDto {
  final _SubjectId id;
  final SubjectGradeCompositionDto gradeComposition;
  final WeightType weightType;
  // TODO: Laut doc nullable?
  final _GradeTypeId finalGradeType;
  final List<_GradeId> grades;

  TermSubjectDto({
    required this.id,
    required this.grades,
    required this.weightType,
    required this.gradeComposition,
    required this.finalGradeType,
  });

  factory TermSubjectDto.fromSubject(SubjectModel subject) {
    return TermSubjectDto(
      id: subject.id.id,
      weightType: subject.weightType,
      grades: subject.grades.map((grade) => grade.id.id).toList(),
      finalGradeType: subject.finalGradeType.id,
      gradeComposition: SubjectGradeCompositionDto.fromSubject(subject),
    );
  }

  factory TermSubjectDto.fromData(Map<String, Object?> data) {
    return TermSubjectDto(
      id: data['id'] as String,
      grades: data['grades'] as List<String>,
      weightType: WeightType.fromString(data['weightType'] as String),
      finalGradeType: data['finalGradeType'] as String,
      gradeComposition: SubjectGradeCompositionDto.fromData(
        data['gradeComposition'] as Map<String, Object>,
      ),
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'grades': grades,
      'gradeComposition': gradeComposition.toData(),
      'weightType': weightType.name,
      'finalGradeType': finalGradeType,
    };
  }
}

class SubjectGradeCompositionDto {
  final WeightType weightType;
  final Map<_GradeTypeId, WeightDto> gradeTypeWeights;
  final Map<_GradeId, WeightDto> gradeWeights;

  SubjectGradeCompositionDto(
      {required this.weightType,
      required this.gradeTypeWeights,
      required this.gradeWeights});

  factory SubjectGradeCompositionDto.fromSubject(SubjectModel subject) {
    return SubjectGradeCompositionDto(
      weightType: subject.weightType,
      gradeTypeWeights: subject.gradeTypeWeightings
          .map((gradeId, weight) => MapEntry(gradeId.id, weight.toDto()))
          .unlock,
      gradeWeights: Map.fromEntries(subject.grades
          .map((grade) => MapEntry(grade.id.id, grade.weight.toDto()))),
    );
  }

  factory SubjectGradeCompositionDto.fromData(Map<String, Object?> data) {
    return SubjectGradeCompositionDto(
      weightType: WeightType.fromString(data['weightType'] as String),
      gradeTypeWeights: data['gradeTypeWeights'].toWeightsDtoMap(),
      gradeWeights: data['gradeWeights'].toWeightsDtoMap(),
    );
  }

  Map<String, Object> toData() {
    return {
      'weightType': weightType.name,
      'gradeTypeWeights': gradeTypeWeights.toWeightDataMap(),
      'gradeWeights': gradeWeights.toWeightDataMap(),
    };
  }
}

class GradeDto {
  final _GradeId id;
  final _TermId termId;
  final _SubjectId subjectId;
  final num numValue;
  final GradingSystem gradingSystem;
  final _GradeTypeId gradeType;
  final Timestamp receivedAt;
  final bool includeInGrading;
  final String title;
  final String? details;

  GradeDto({
    required this.id,
    required this.termId,
    required this.subjectId,
    required this.numValue,
    required this.gradingSystem,
    required this.gradeType,
    required this.receivedAt,
    required this.includeInGrading,
    required this.title,
    required this.details,
  });

  factory GradeDto.fromGrade(GradeModel grade) {
    return GradeDto(
      id: grade.id.id,
      termId: grade.termId.id,
      subjectId: grade.subjectId.id,
      numValue: grade.value.asNum,
      gradingSystem: grade.gradingSystem.spec.gradingSystem,
      gradeType: grade.gradeType.id,
      receivedAt: Timestamp.fromDate(grade.date.toDateTime),
      includeInGrading: grade.takenIntoAccount,
      title: grade.title,
      details: grade.details,
    );
  }

  factory GradeDto.fromData(Map<String, Object?> data) {
    return GradeDto(
      id: data['id'] as String,
      termId: data['termId'] as String,
      subjectId: data['subjectId'] as String,
      numValue: data['numValue'] as num,
      gradingSystem: GradingSystem.fromString(data['gradingSystem'] as String),
      gradeType: data['gradeType'] as String,
      receivedAt: data['receivedAt'] as Timestamp,
      includeInGrading: data['includeInGrading'] as bool,
      title: data['title'] as String,
      details: data['details'] as String?,
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'termId': termId,
      'subjectId': subjectId,
      'numValue': numValue,
      'gradingSystem': gradingSystem.name,
      'gradeType': gradeType,
      'receivedAt': receivedAt,
      'includeInGrading': includeInGrading,
      'title': title,
      if (details != null) 'details': details!,
    };
  }
}

class SubjectDto {
  final _SubjectId id;
  final String name;
  final String abbreviation;
  final Design design;
  final IList<ConnectedCourseDto> connectedCourses;

  SubjectDto({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.design,
    required this.connectedCourses,
  });

  factory SubjectDto.fromSubject(Subject subject) {
    return SubjectDto(
      id: subject.id.id,
      design: subject.design,
      name: subject.name,
      abbreviation: subject.abbreviation,
      connectedCourses: subject.connectedCourses
          .map((cc) => ConnectedCourseDto.fromConnectedCourse(cc))
          .toIList(),
    );
  }

  factory SubjectDto.fromData(Map<String, Object?> data) {
    return SubjectDto(
        id: data['id'] as String,
        name: data['name'] as String,
        abbreviation: data['abbreviation'] as String,
        design: Design.fromData(data['design']),
        connectedCourses:
            (data['connectedCourses'] as Map<String, Map<String, Object>>)
                .mapTo((key, value) => ConnectedCourseDto.fromData(value))
                .toIList());
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'design': design.toJson(),
      'connectedCourses':
          connectedCourses.map((cc) => MapEntry(cc.id, cc.toData())).toMap(),
    };
  }
}

class ConnectedCourseDto {
  final String id;
  final String name;
  final String abbreviation;
  final String subjectName;

  ConnectedCourseDto({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.subjectName,
  });

  factory ConnectedCourseDto.fromConnectedCourse(ConnectedCourse course) {
    return ConnectedCourseDto(
      id: course.id.id,
      name: course.name,
      abbreviation: course.abbreviation,
      subjectName: course.subjectName,
    );
  }

  factory ConnectedCourseDto.fromData(Map<String, Object?> data) {
    return ConnectedCourseDto(
      id: data['id'] as String,
      name: data['name'] as String,
      abbreviation: data['abbreviation'] as String,
      subjectName: data['subjectName'] as String,
    );
  }

  ConnectedCourse toConnectedCourse() {
    return ConnectedCourse(
      id: CourseId(id),
      name: name,
      abbreviation: abbreviation,
      subjectName: subjectName,
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'subjectName': subjectName,
    };
  }
}
