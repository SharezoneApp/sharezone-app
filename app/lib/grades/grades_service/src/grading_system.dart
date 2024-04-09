// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../grades_service.dart';

extension _ToGradingSystem on GradingSystem {
  _GradingSystem toGradingSystem() {
    switch (this) {
      case GradingSystem.zeroToHundredPercentWithDecimals:
        return _GradingSystem.zeroToHundredPercentWithDecimals;
      case GradingSystem.zeroToFivteenPoints:
        return _GradingSystem.zeroToFiveteenPoints;
      case GradingSystem.oneToSixWithPlusAndMinus:
        return _GradingSystem.oneToSixWithPlusAndMinus;
      case GradingSystem.oneToSixWithDecimals:
        return _GradingSystem.oneToSixWithDecimals;
      case GradingSystem.austrianBehaviouralGrades:
        return _GradingSystem.austrianBehaviouralGrades;
      case GradingSystem.oneToFiveWithDecimals:
        return _GradingSystem.oneToFiveWithDecimals;
      case GradingSystem.sixToOneWithDecimals:
        return _GradingSystem.sixToOneWithDecimals;
    }
  }
}

extension _ToGradingSystems on _GradingSystem {
  GradingSystem toGradingSystems() {
    return spec.gradingSystem;
  }
}

class _GradingSystem {
  static final oneToSixWithPlusAndMinus =
      _GradingSystem(spec: oneToSixWithPlusAndMinusSpec);
  static final zeroToFiveteenPoints =
      _GradingSystem(spec: zeroToFivteenPointsSpec);
  static final oneToSixWithDecimals =
      _GradingSystem(spec: oneToSixWithDecimalsSpec);
  static final zeroToHundredPercentWithDecimals =
      _GradingSystem(spec: zeroToHundredPercentWithDecimalsSpec);
  static final austrianBehaviouralGrades =
      _GradingSystem(spec: austrianBehaviouralGradesSpec);
  static final oneToFiveWithDecimals =
      _GradingSystem(spec: oneToFiveWithDecimalsSpec);
  static final sixToOneWithDecimals =
      _GradingSystem(spec: sixToOneWithDecimalsSpec);

  final GradingSystemSpec spec;

  _GradingSystem({required this.spec});

  num _toNumOrThrow(String grade) {
    // 2,3 -> 2.3 (format expected by num.tryParse())
    grade = grade.replaceAll(',', '.');

    final asNum = num.tryParse(grade);
    if (asNum != null) {
      return asNum;
    }

    final asSpecialGrade = spec.specialDisplayableGradeToNumOrNull?.call(grade);
    if (asSpecialGrade != null) {
      return asSpecialGrade;
    }

    throw ArgumentError('Invalid grade value');
  }

  PossibleGradesResult get possibleGrades => spec.possibleGrades;

  GradeValue toGradeResult(num grade) {
    return GradeValue(
      asNum: grade,
      displayableGrade: spec.getSpecialDisplayableGradeOrNull?.call(grade),
      suffix: spec == zeroToHundredPercentWithDecimalsSpec ? '%' : null,
    );
  }

  num toNumOrThrow(Object grade) {
    if (grade is num) return grade;
    if (grade is String) {
      final possGrades = possibleGrades;
      if (possGrades is NonNumericalPossibleGradesResult &&
          !possGrades.grades.contains(grade)) {
        throw InvalidGradeValueException(
          gradeInput: grade,
          gradingSystem: toGradingSystems(),
        );
      }
      try {
        final db = _toNumOrThrow(grade);
        if (possGrades is ContinuousNumericalPossibleGradesResult) {
          if (db < possGrades.min || db > possGrades.max) {
            throw InvalidGradeValueException(
              gradeInput: grade.toString(),
              gradingSystem: toGradingSystems(),
            );
          }
        }
        return db;
      } on InvalidGradeValueException {
        rethrow;
      } catch (e) {
        throw InvalidGradeValueException(
          gradeInput: grade,
          gradingSystem: toGradingSystems(),
        );
      }
    }
    throw ArgumentError(
        "Couldn't convert grade ($grade) to num: grade must be a num or string, but was ${grade.runtimeType}.");
  }
}

class GradingSystemSpec {
  final GradingSystem gradingSystem;
  final PossibleGradesResult possibleGrades;
  final num? Function(String grade)? specialDisplayableGradeToNumOrNull;
  final String? Function(num grade)? getSpecialDisplayableGradeOrNull;

  const GradingSystemSpec({
    required this.gradingSystem,
    required this.possibleGrades,
    this.specialDisplayableGradeToNumOrNull,
    this.getSpecialDisplayableGradeOrNull,
  });

  /// Creates a [GradingSystemSpec] for a non-numerical grading system.
  ///
  /// The [specialGrades] map still contains numbers so that calculations
  /// can be done with them and that one might check how close a averaged
  /// grade is to one of the special grades.
  factory GradingSystemSpec.nonNumerical(
    GradingSystem gradingSystem,
    IMapConst<String, num> specialGrades,
  ) {
    return GradingSystemSpec(
      gradingSystem: gradingSystem,
      possibleGrades:
          NonNumericalPossibleGradesResult(specialGrades.keys.toIList()),
      specialDisplayableGradeToNumOrNull: (grade) {
        return specialGrades[grade];
      },
      getSpecialDisplayableGradeOrNull: (grade) {
        return specialGrades.entries
            .firstWhereOrNull((entry) => entry.value == grade)
            ?.key;
      },
    );
  }
}

final oneToSixWithPlusAndMinusSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
  possibleGrades: const ContinuousNumericalPossibleGradesResult(
      min: 0.75,
      max: 6,
      decimalsAllowed: true,
      specialGrades: IMapConst({
        '1+': 0.75,
        '1-': 1.25,
        '2+': 1.75,
        '2-': 2.25,
        '3+': 2.75,
        '3-': 3.25,
        '4+': 3.75,
        '4-': 4.25,
        '5+': 4.75,
        '5-': 5.25,
      })),
  specialDisplayableGradeToNumOrNull: (grade) {
    return switch (grade) {
      '1+' => 0.75,
      '1-' => 1.25,
      '2+' => 1.75,
      '2-' => 2.25,
      '3+' => 2.75,
      '3-' => 3.25,
      '4+' => 3.75,
      '4-' => 4.25,
      '5+' => 4.75,
      '5-' => 5.25,
      _ => null,
    };
  },
  getSpecialDisplayableGradeOrNull: (grade) {
    return switch (grade) {
      0.75 => '1+',
      1.25 => '1-',
      1.75 => '2+',
      2.25 => '2-',
      2.75 => '3+',
      3.25 => '3-',
      3.75 => '4+',
      4.25 => '4-',
      4.75 => '5+',
      5.25 => '5-',
      _ => null,
    };
  },
);

const oneToFiveWithDecimalsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.oneToFiveWithDecimals,
  possibleGrades: ContinuousNumericalPossibleGradesResult(
    min: 0.75,
    max: 5,
    decimalsAllowed: true,
  ),
);

const zeroToFivteenPointsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.zeroToFivteenPoints,
  possibleGrades: ContinuousNumericalPossibleGradesResult(
    min: 0,
    max: 15,
    decimalsAllowed: false,
  ),
);

const oneToSixWithDecimalsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.oneToSixWithDecimals,
  possibleGrades: ContinuousNumericalPossibleGradesResult(
    // 0.66 is the lowest grade possible and equals "1+".
    // Depending on where one lives the lowest grade might be 0.75
    // or 0.66 (both equal 1+). So we just use 0.66 here so that
    // every system can be covered.
    min: 0.66,
    max: 6,
    decimalsAllowed: true,
  ),
);

const sixToOneWithDecimalsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.sixToOneWithDecimals,
  possibleGrades: ContinuousNumericalPossibleGradesResult(
    min: 1,
    max: 6,
    decimalsAllowed: true,
  ),
);

const zeroToHundredPercentWithDecimalsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
  possibleGrades: ContinuousNumericalPossibleGradesResult(
    min: 0,
    max: 100,
    decimalsAllowed: true,
  ),
);

final austrianBehaviouralGradesSpec = GradingSystemSpec.nonNumerical(
  GradingSystem.austrianBehaviouralGrades,
  const IMapConst({
    'Sehr zufriedenstellend': 1,
    'Zufriedenstellend': 2,
    'Wenig zufriedenstellend': 4,
    'Nicht zufriedenstellend': 3,
  }),
);
