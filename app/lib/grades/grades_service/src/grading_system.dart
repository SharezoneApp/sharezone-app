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
      case GradingSystem.zeroToFivteenPoints:
        return _GradingSystem.zeroToFiveteenPoints;
      case GradingSystem.oneToSixWithPlusAndMinus:
        return _GradingSystem.oneToSixWithPlusAndMinus;
      case GradingSystem.oneToSixWithDecimals:
        return _GradingSystem.oneToSixWithDecimals;
    }
  }
}

extension _ToGradingSystems on _GradingSystem {
  GradingSystem toGradingSystems() {
    if (this is ZeroToFiveteenPointsGradingSystem) {
      return GradingSystem.zeroToFivteenPoints;
    } else if (this is OneToSixWithPlusMinusGradingSystem) {
      return GradingSystem.oneToSixWithPlusAndMinus;
    } else if (this is OneToSixWithDecimalsGradingSystem) {
      return GradingSystem.oneToSixWithDecimals;
    } else {
      throw UnimplementedError();
    }
  }
}

sealed class _GradingSystem {
  static final oneToSixWithPlusAndMinus = OneToSixWithPlusMinusGradingSystem();
  static final zeroToFiveteenPoints = ZeroToFiveteenPointsGradingSystem();
  static final oneToSixWithDecimals = OneToSixWithDecimalsGradingSystem();

  double toDoubleOrThrow(String grade);
  PossibleGradesResult get possibleGrades;

  CalculatedGradeResult toGradeResult(num grade) {
    final displayableGrade = toDisplayableGrade(grade);
    return CalculatedGradeResult(
      asNum: grade,
      displayableGrade: displayableGrade,
    );
  }

  int nrOfDecimalsForDisplayableGrade = 1;

  String toDisplayableGrade(num grade) {
    final res = getDisplayableGradeIfExactMatch(grade);
    if (res != null) {
      return res;
    }
    return grade
        .toStringAsFixed(nrOfDecimalsForDisplayableGrade + 2)
        .replaceAll('.', ',')
        .substring(0, nrOfDecimalsForDisplayableGrade + 2);
  }

  String? getDisplayableGradeIfExactMatch(num grade);
}

class ZeroToFiveteenPointsGradingSystem extends _GradingSystem
    with EquatableMixin {
  @override
  DiscretePossibleGradesResult get possibleGrades =>
      const DiscretePossibleGradesResult(IListConst([
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
      ]));

  @override
  double toDoubleOrThrow(String grade) {
    return double.parse(grade);
  }

  @override
  List<Object?> get props => [];

  @override
  String? getDisplayableGradeIfExactMatch(num grade) {
    for (var val in possibleGrades.grades) {
      if (int.parse(val) == grade) {
        return val;
      }
    }
    return null;
  }
}

class OneToSixWithPlusMinusGradingSystem extends _GradingSystem
    with EquatableMixin {
  @override
  DiscretePossibleGradesResult get possibleGrades =>
      const DiscretePossibleGradesResult(IListConst([
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
      ]));

  @override
  double toDoubleOrThrow(String grade) {
    return switch (grade) {
      '1+' => 0.75,
      '1' => 1,
      '1-' => 1.25,
      '2+' => 1.75,
      '2' => 2,
      '2-' => 2.25,
      '3+' => 2.75,
      '3' => 3,
      '3-' => 3.25,
      '4+' => 3.75,
      '4' => 4,
      '4-' => 4.25,
      '5+' => 4.75,
      '5' => 5,
      '5-' => 5.25,
      '6' => 6,
      _ => throw ArgumentError.value(
          grade,
          'grade',
          'Invalid grade value',
        ),
    };
  }

  @override
  List<Object?> get props => [];

  @override
  String? getDisplayableGradeIfExactMatch(num grade) {
    for (var val in possibleGrades.grades) {
      if (toDoubleOrThrow(val) == grade) {
        return val;
      }
    }
    return null;
  }
}

class OneToSixWithDecimalsGradingSystem extends _GradingSystem
    with EquatableMixin {
  @override
  NonDiscretePossibleGradesResult get possibleGrades =>
  // TODO: Validate min/max in logic?
      const NonDiscretePossibleGradesResult(
        min: 0.75,
        max: 6,
        decimalsAllowed: true,
      );

  @override
  double toDoubleOrThrow(String grade) {
    // TODO: test
    return double.parse(grade);
  }

  @override
  List<Object?> get props => [];

  // Since students would often add grades with two decimals (e.g. 1.25 (1-)),
  // we want to display the grade with two decimals.
  @override
  int get nrOfDecimalsForDisplayableGrade => 2;

  @override
  String? getDisplayableGradeIfExactMatch(num grade) {
    return null;
  }
}
