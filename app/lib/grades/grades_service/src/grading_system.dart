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

  final GradingSystemSpec spec;

  _GradingSystem({required this.spec});

  num toNumOrThrow(String grade) {
    grade = grade.replaceAll(',', '.');
    return num.tryParse(grade) ??
        spec.specialDisplayableGradeToNumOrNull?.call(grade) ??
        () {
          throw ArgumentError('Invalid grade value');
        }();
  }

  PossibleGradesResult get possibleGrades => spec.possibleGrades;

  GradeValue toGradeResult(num grade) {
    return GradeValue(
      asNum: grade,
      displayableGrade: getSpecialDisplayableGradeIfAvailable(grade),
      suffix: spec == zeroToHundredPercentWithDecimalsSpec ? '%' : null,
    );
  }

  String? getSpecialDisplayableGradeIfAvailable(num grade) {
    return spec.getSpecialDisplayableGradeIfAvailable?.call(grade);
  }
}

class GradingSystemSpec {
  final GradingSystem gradingSystem;
  final PossibleGradesResult possibleGrades;
  final num? Function(String grade)? specialDisplayableGradeToNumOrNull;
  final String? Function(num grade)? getSpecialDisplayableGradeIfAvailable;

  const GradingSystemSpec({
    required this.gradingSystem,
    required this.possibleGrades,
    this.specialDisplayableGradeToNumOrNull,
    this.getSpecialDisplayableGradeIfAvailable,
  });
}

final oneToSixWithPlusAndMinusSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
  possibleGrades: const DiscretePossibleGradesResult(IListConst([
    '1+',
    '1',
    '1-',
    '2+',
    '2',
    '2-',
    '3+',
    '3',
    '3-',
    '4+',
    '4',
    '4-',
    '5+',
    '5',
    '5-',
    '6',
  ])),
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
  getSpecialDisplayableGradeIfAvailable: (grade) {
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
  possibleGrades: NonDiscretePossibleGradesResult(
    min: 0.75,
    max: 5,
    decimalsAllowed: true,
  ),
);

const zeroToFivteenPointsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.zeroToFivteenPoints,
  possibleGrades: DiscretePossibleGradesResult(IListConst([
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
  ])),
);

const oneToSixWithDecimalsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.oneToSixWithDecimals,
  possibleGrades: NonDiscretePossibleGradesResult(
    // 0.66 is the lowest grade possible and equals "1+".
    // Depending on where one lives the lowest grade might be 0.75
    // or 0.66 (both equal 1+). So we just use 0.66 here so that
    // every system can be covered.
    min: 0.66,
    max: 6,
    decimalsAllowed: true,
  ),
);

const zeroToHundredPercentWithDecimalsSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.zeroToHundredPercentWithDecimals,
  possibleGrades: NonDiscretePossibleGradesResult(
    min: 0,
    max: 100,
    decimalsAllowed: true,
  ),
);

final austrianBehaviouralGradesSpec = GradingSystemSpec(
  gradingSystem: GradingSystem.austrianBehaviouralGrades,
  possibleGrades: const DiscretePossibleGradesResult(IListConst([
    'Sehr zufriedenstellend',
    'Zufriedenstellend',
    'Wenig zufriedenstellend',
    'Nicht zufriedenstellend',
  ])),
  specialDisplayableGradeToNumOrNull: (grade) {
    return switch (grade) {
      'Sehr zufriedenstellend' => 1,
      'Zufriedenstellend' => 2,
      'Wenig zufriedenstellend' => 4,
      'Nicht zufriedenstellend' => 3,
      _ => null,
    };
  },
  getSpecialDisplayableGradeIfAvailable: (grade) {
    return switch (grade) {
      1 => 'Sehr zufriedenstellend',
      2 => 'Zufriedenstellend',
      4 => 'Wenig zufriedenstellend',
      3 => 'Nicht zufriedenstellend',
      _ => null,
    };
  },
);
