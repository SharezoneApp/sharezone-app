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
  IList<TermModel> terms,
  IList<GradeType> customGradeTypes,
  IList<Subject> subjects
});

extension GradesStateCopyWith on GradesState {
  bool get isEmpty =>
      terms.isEmpty && customGradeTypes.isEmpty && subjects.isEmpty;

  GradesState copyWith({
    IList<TermModel>? terms,
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

  Map<String, Object?> data = {};

  @override
  void updateState(GradesState state) {
    // We use the Firestore Repository methods so we test the (de)serialization
    // even in our unit tests, which means a bigger test coverage.
    data = FirestoreGradesStateRepository.toDto(state);
    // debugPrint(json.encode(data, toEncodable: (val) {
    //   if (val is Timestamp) {
    //     return val.millisecondsSinceEpoch;
    //   }
    // }));
    this.state.add(FirestoreGradesStateRepository.fromData(data));
  }
}

class FirestoreGradesStateRepository extends GradesStateRepository {
  final DocumentReference userDocumentRef;
  DocumentReference get gradesDocumentRef =>
      userDocumentRef.collection('Grades').doc('AllInOne');
  bool? topLevelCreatedOnExists;

  FirestoreGradesStateRepository({required this.userDocumentRef}) {
    gradesDocumentRef.snapshots().listen((event) {
      if (!event.exists) {
        topLevelCreatedOnExists = false;
        return;
      }
      final data = event.data() as Map<String, Object?>;
      final newState = fromData(data);
      state.add(newState);

      topLevelCreatedOnExists = data['createdOn'] != null;

      // debugPrint(json.encode(data, toEncodable: (val) {
      //   if (val is Timestamp) {
      //     return val.millisecondsSinceEpoch;
      //   }
      // }));
    });
  }

  @override
  BehaviorSubject<GradesState> state = BehaviorSubject<GradesState>.seeded(
    (
      terms: const IListConst([]),
      customGradeTypes: const IListConst([]),
      subjects: const IListConst([]),
    ),
  );

  @override
  Future<void> updateState(GradesState state) async {
    // We only want to create the document here, since we're unsure if the top
    // level createdOn field already exists or not. This should realistically
    // never happen.
    if (topLevelCreatedOnExists == null) {
      // Without <String, Object?> an error is thrown.
      gradesDocumentRef.set(<String, Object?>{}, SetOptions(merge: true));
    }

    // We're sure that the top level createdOn does not exist yet, so we add it.
    // This will also create the document if it doesn't exist yet.
    if (topLevelCreatedOnExists == false) {
      gradesDocumentRef.set(
        {'createdOn': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    }

    final data = toDto(state);
    // Adding the top level createdOn should've created the document if it
    // didn't exist yet. Thus we can use update instead of set here, which is
    // the only way that deleting grades or terms work, since set (with merge
    // being true) will never delete fields.
    gradesDocumentRef.update(data);
  }

  static Map<String, Object?> toDto(GradesState state) {
    final currentTermOrNull =
        state.terms.firstWhereOrNull((term) => term.isActiveTerm)?.id.value;
    return {
      'currentTerm': currentTermOrNull,
      'terms': state.terms
          .map((term) =>
              MapEntry(term.id.value, TermDto.fromTerm(term).toData()))
          .toMap(),
      'grades': state.terms
          .expand((term) => term.subjects.expand((p0) => p0.grades))
          .map((g) => MapEntry(g.id.value, GradeDto.fromGrade(g).toData()))
          .toMap(),
      'customGradeTypes': state.customGradeTypes
          .map((element) => MapEntry(element.id.value,
              CustomGradeTypeDto.fromGradeType(element).toData()))
          .toMap(),
      'subjects': state.subjects
          .map((subject) => MapEntry(
              subject.id.value, SubjectDto.fromSubject(subject).toData()))
          .toMap()
    };
  }

  static GradesState fromData(Map<String, Object?> data) {
    IList<TermDto> termDtos = const IListConst([]);

    // Cant use this from data from Firestore as the maps and Lists are all
    // dynamic.
    // if (data case {'terms': Map<String, Map<String, Object?>> termData}) {
    if (data case {'terms': Map termData}) {
      termDtos =
          termData.mapTo((value, key) => TermDto.fromData(key)).toIList();
    }

    IList<SubjectDto> subjectDtos = const IListConst([]);
    if (data case {'subjects': Map subjectData}) {
      subjectDtos =
          subjectData.mapTo((value, key) => SubjectDto.fromData(key)).toIList();
    }

    IList<GradeDto> gradeDtos = const IListConst([]);
    if (data case {'grades': Map gradeData}) {
      gradeDtos =
          gradeData.mapTo((value, key) => GradeDto.fromData(key)).toIList();
    }

    IList<CustomGradeTypeDto> customGradeTypeDtos = const IListConst([]);
    if (data case {'customGradeTypes': Map gradeTypeData}) {
      customGradeTypeDtos = gradeTypeData
          .mapTo((value, key) => CustomGradeTypeDto.fromData(key))
          .toIList();
    }

    final grades = gradeDtos.map(
      (dto) {
        final gradingSystem = dto.gradingSystem.toGradingSystemModel();
        return GradeModel(
          id: GradeId(dto.id),
          termId: TermId(dto.termId),
          date: dto.receivedAt,
          gradingSystem: gradingSystem,
          gradeType: GradeTypeId(dto.gradeType),
          subjectId: SubjectId(dto.subjectId),
          takenIntoAccount: dto.includeInGrading,
          title: dto.title,
          details: dto.details,
          createdOn: dto.createdOn?.toDate(),
          value: gradingSystem.toGradeResult(dto.numValue),
          originalInput: dto.originalInput,
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
          createdOn: dto.createdOn?.toDate(),
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
              (subject) => subject.id.value == termSub.termSubject.id);
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

      final subTerm =
          termDtos.firstWhere((term) => term.id == termSubjectObj.termId);
      return SubjectModel(
        id: subject.id,
        termId: TermId(subTerm.id),
        name: subject.name,
        connectedCourses: subject.connectedCourses,
        createdOn: termSubject.createdOn?.toDate(),
        isFinalGradeTypeOverridden:
            termSubject.finalGradeType != subTerm.finalGradeTypeId,
        gradeTypeWeightings: termSubject.gradeComposition.gradeTypeWeights
            .map((key, value) => MapEntry(GradeTypeId(key), value.toWeight()))
            .toIMap(),
        gradeTypeWeightingsFromTerm: subTerm.gradeTypeWeights
            .map((key, value) => MapEntry(GradeTypeId(key), value.toWeight()))
            .toIMap(),
        weightingForTermGrade:
            subTerm.subjectWeights[subject.id.value]?.toWeight() ??
                const Weight.factor(1),
        grades: grades
            .where((grade) =>
                grade.subjectId == subject.id && grade.termId.value == termId)
            .toIList(),
        weightType: termSubject.gradeComposition.weightType,
        gradingSystem: subTerm.gradingSystem.toGradingSystemModel(),
        finalGradeType: GradeTypeId(termSubject.finalGradeType),
        abbreviation: subject.abbreviation,
        design: subject.design,
      );
    }).toIList();

    var terms = termDtos
        .map(
          (dto) => TermModel(
            id: TermId(dto.id),
            finalGradeType: GradeTypeId(dto.finalGradeTypeId),
            createdOn: dto.createdOn?.toDate(),
            gradingSystem: dto.gradingSystem.toGradingSystemModel(),
            isActiveTerm: data['currentTerm'] == dto.id,
            subjects: termSubjects
                .where((subject) => subject.termId.value == dto.id)
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
  // We use FieldValue.serverTimestamp() as a value, which will create an error
  // in local-only unit tests as the FieldValue is not converted to a Timestamp
  // as expected when using Firestore. This is why we use this method to check
  // if the value is a Timestamp or not so no error is thrown when running this
  // code in our local unit tests.
  Timestamp? tryConvertToTimestampOrNull() {
    if (this is Timestamp?) {
      return this as Timestamp?;
    } else {
      return null;
    }
  }
}

extension on DateTime? {
  Timestamp? toTimestampOrNull() =>
      this == null ? null : Timestamp.fromDate(this!);
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
  return (data as Map)
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
      id: gradeType.id.value,
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
  final Timestamp? createdOn;
  final GradingSystem gradingSystem;
  final Map<_SubjectId, WeightDto> subjectWeights;
  final Map<_GradeTypeId, WeightDto> gradeTypeWeights;
  final List<TermSubjectDto> subjects;
  final _GradeTypeId finalGradeTypeId;

  TermDto({
    required this.id,
    required this.displayName,
    required this.createdOn,
    required this.gradingSystem,
    required this.subjectWeights,
    required this.gradeTypeWeights,
    required this.finalGradeTypeId,
    required this.subjects,
  });

  factory TermDto.fromTerm(TermModel term) {
    return TermDto(
      id: term.id.value,
      displayName: term.name,
      createdOn: term.createdOn?.toTimestampOrNull(),
      finalGradeTypeId: term.finalGradeType.value,
      gradingSystem: term.gradingSystem.spec.gradingSystem,
      subjects: term.subjects.map(TermSubjectDto.fromSubject).toList(),
      subjectWeights: Map.fromEntries(term.subjects.map((subject) =>
          MapEntry(subject.id.value, subject.weightingForTermGrade.toDto()))),
      gradeTypeWeights: term.gradeTypeWeightings
          .map((gradeId, weight) => MapEntry(gradeId.value, weight.toDto()))
          .unlock,
    );
  }

  factory TermDto.fromData(Map<String, Object?> data) {
    return TermDto(
      id: data['id'] as String,
      displayName: data['displayName'] as String,
      createdOn: data['createdOn'].tryConvertToTimestampOrNull(),
      gradingSystem:
          GradingSystem.values.byName(data['gradingSystem'] as String),
      subjectWeights: data['subjectWeights'].toWeightsDtoMap(),
      gradeTypeWeights: data['gradeTypeWeights'].toWeightsDtoMap(),
      subjects: (data['subjects'] as Map)
          .mapTo((_, sub) => TermSubjectDto.fromData(sub))
          .toList(),
      finalGradeTypeId: data['finalGradeType'] as String,
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'displayName': displayName,
      if (createdOn != null) 'createdOn': createdOn!,
      if (createdOn == null) 'createdOn': FieldValue.serverTimestamp(),
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
  final _GradeTypeId finalGradeType;
  final List<_GradeId> grades;
  final Timestamp? createdOn;

  TermSubjectDto({
    required this.id,
    required this.grades,
    required this.gradeComposition,
    required this.finalGradeType,
    required this.createdOn,
  });

  factory TermSubjectDto.fromSubject(SubjectModel subject) {
    return TermSubjectDto(
      id: subject.id.value,
      grades: subject.grades.map((grade) => grade.id.value).toList(),
      finalGradeType: subject.finalGradeType.value,
      gradeComposition: SubjectGradeCompositionDto.fromSubject(subject),
      createdOn: subject.createdOn?.toTimestampOrNull(),
    );
  }

  factory TermSubjectDto.fromData(Map<String, Object?> data) {
    return TermSubjectDto(
      id: data['id'] as String,
      grades: decodeList(data['grades'], (g) => g as String),
      finalGradeType: data['finalGradeType'] as String,
      gradeComposition: SubjectGradeCompositionDto.fromData(
        decodeMap(data['gradeComposition'],
            (key, decodedMapValue) => decodedMapValue as Object),
      ),
      createdOn: data['createdOn'].tryConvertToTimestampOrNull(),
    );
  }

  Map<String, Object> toData() {
    return {
      'id': id,
      'grades': grades,
      'gradeComposition': gradeComposition.toData(),
      'finalGradeType': finalGradeType,
      if (createdOn != null) 'createdOn': createdOn!,
      if (createdOn == null) 'createdOn': FieldValue.serverTimestamp(),
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
          .map((gradeId, weight) => MapEntry(gradeId.value, weight.toDto()))
          .unlock,
      gradeWeights: Map.fromEntries(subject.grades
          .map((grade) => MapEntry(grade.id.value, grade.weight.toDto()))),
    );
  }

  factory SubjectGradeCompositionDto.fromData(Map<String, Object?> data) {
    return SubjectGradeCompositionDto(
      weightType: WeightType.values.byName(data['weightType'] as String),
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
  final Timestamp? createdOn;
  final _TermId termId;
  final _SubjectId subjectId;
  final num numValue;
  final GradingSystem gradingSystem;
  final _GradeTypeId gradeType;
  final Date receivedAt;
  final bool includeInGrading;
  final String title;
  final String? details;
  final Object originalInput;

  GradeDto(
      {required this.id,
      required this.termId,
      required this.subjectId,
      required this.numValue,
      required this.gradingSystem,
      required this.gradeType,
      required this.receivedAt,
      required this.includeInGrading,
      required this.title,
      required this.details,
      required this.createdOn,
      required this.originalInput});

  factory GradeDto.fromGrade(GradeModel grade) {
    return GradeDto(
      id: grade.id.value,
      termId: grade.termId.value,
      subjectId: grade.subjectId.value,
      numValue: grade.value.asNum,
      originalInput: grade.originalInput,
      gradingSystem: grade.gradingSystem.spec.gradingSystem,
      gradeType: grade.gradeType.value,
      receivedAt: grade.date,
      includeInGrading: grade.takenIntoAccount,
      title: grade.title,
      details: grade.details,
      createdOn: grade.createdOn?.toTimestampOrNull(),
    );
  }

  factory GradeDto.fromData(Map<String, Object?> data) {
    return GradeDto(
      id: data['id'] as String,
      termId: data['termId'] as String,
      subjectId: data['subjectId'] as String,
      numValue: data['numValue'] as num,
      originalInput: data['originalInput'] as Object,
      gradingSystem:
          GradingSystem.values.byName(data['gradingSystem'] as String),
      gradeType: data['gradeType'] as String,
      receivedAt: Date.parse(data['receivedAt'] as String),
      includeInGrading: data['includeInGrading'] as bool,
      title: data['title'] as String,
      details: data['details'] as String?,
      createdOn: data['createdOn'].tryConvertToTimestampOrNull(),
    );
  }

  Map<String, Object> toData() {
    // Currently the originalInput would use the grade display string for the
    // original value but we want to transition to using an Enum in the future.
    // We use this to fake using an enum for the original value. We'll implement
    // really using the enum in the future.
    Object originalInp = originalInput;
    if (gradingSystem == GradingSystem.austrianBehaviouralGrades) {
      originalInp = getAustrianBehaviouralGradeDbKeyFromNum(numValue);
    }
    return {
      'id': id,
      'termId': termId,
      'subjectId': subjectId,
      'originalInput': originalInp,
      'numValue': numValue,
      'gradingSystem': gradingSystem.name,
      'gradeType': gradeType,
      'receivedAt': receivedAt.toDateString,
      'includeInGrading': includeInGrading,
      'title': title,
      if (details != null) 'details': details!,
      if (createdOn == null) 'createdOn': FieldValue.serverTimestamp(),
      if (createdOn != null) 'createdOn': createdOn!,
    };
  }
}

class SubjectDto {
  final _SubjectId id;
  final String name;
  final String abbreviation;
  final Design design;
  final IList<ConnectedCourseDto> connectedCourses;
  final Timestamp? createdOn;

  SubjectDto({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.design,
    required this.connectedCourses,
    required this.createdOn,
  });

  factory SubjectDto.fromSubject(Subject subject) {
    return SubjectDto(
      id: subject.id.value,
      design: subject.design,
      name: subject.name,
      abbreviation: subject.abbreviation,
      createdOn: subject.createdOn.toTimestampOrNull(),
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
        createdOn: data['createdOn'].tryConvertToTimestampOrNull(),
        connectedCourses: (data['connectedCourses'] as Map)
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
      if (createdOn == null) 'createdOn': FieldValue.serverTimestamp(),
      if (createdOn != null) 'createdOn': createdOn!,
    };
  }
}

class ConnectedCourseDto {
  final String id;
  final String name;
  final String abbreviation;
  final String subjectName;
  final Timestamp? addedOn;

  ConnectedCourseDto({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.subjectName,
    required this.addedOn,
  });

  factory ConnectedCourseDto.fromConnectedCourse(ConnectedCourse course) {
    return ConnectedCourseDto(
      id: course.id.value,
      name: course.name,
      abbreviation: course.abbreviation,
      subjectName: course.subjectName,
      addedOn: course.addedOn.toTimestampOrNull(),
    );
  }

  factory ConnectedCourseDto.fromData(Map<String, Object?> data) {
    return ConnectedCourseDto(
      id: data['id'] as String,
      name: data['name'] as String,
      abbreviation: data['abbreviation'] as String,
      subjectName: data['subjectName'] as String,
      addedOn: data['addedOn'].tryConvertToTimestampOrNull(),
    );
  }

  ConnectedCourse toConnectedCourse() {
    return ConnectedCourse(
      id: CourseId(id),
      name: name,
      abbreviation: abbreviation,
      subjectName: subjectName,
      addedOn: addedOn?.toDate(),
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
