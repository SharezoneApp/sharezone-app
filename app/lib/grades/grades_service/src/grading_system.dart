// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

extension ToGradingSystem on GradingSystems {
  GradingSystem toGradingSystem() {
    switch (this) {
      case GradingSystems.oneToFiveteenPoints:
        return GradingSystem.oneToFiveteenPoints;
      case GradingSystems.oneToSixWithPlusAndMinus:
        return GradingSystem.oneToSixWithPlusAndMinus;
    }
  }
}

extension ToGradingSystems on GradingSystem {
  GradingSystems toGradingSystems() {
    if (this is OneToFiveteenPointsGradingSystem) {
      return GradingSystems.oneToFiveteenPoints;
    } else if (this is OneToSixWithPlusMinusGradingSystem) {
      return GradingSystems.oneToSixWithPlusAndMinus;
    }
    throw UnimplementedError();
  }
}

sealed class GradingSystem {
  static final oneToSixWithPlusAndMinus = OneToSixWithPlusMinusGradingSystem();
  static final oneToFiveteenPoints = OneToFiveteenPointsGradingSystem();

  double toDoubleOrThrow(String grade);
  IList<String> get possibleValues;

  CalculatedGradeResult toGradeResult(num grade) {
    final displayableGrade = toDisplayableGrade(grade);
    return CalculatedGradeResult(
      asNum: grade,
      displayableGrade: displayableGrade,
    );
  }

  String toDisplayableGrade(num grade) {
    final res = getDisplayableGradeIfExactMatch(grade);
    if (res != null) {
      return res;
    }
    return grade.toStringAsFixed(2).replaceAll('.', ',').substring(0, 3);
  }

  String? getDisplayableGradeIfExactMatch(num grade);
}

class OneToFiveteenPointsGradingSystem extends GradingSystem
    with EquatableMixin {
  @override
  IList<String> get possibleValues => const IListConst([
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
      ]);

  @override
  double toDoubleOrThrow(String grade) {
    return double.parse(grade);
  }

  @override
  List<Object?> get props => [];

  @override
  String? getDisplayableGradeIfExactMatch(num grade) {
    for (var val in possibleValues) {
      if (int.parse(val) == grade) {
        return val;
      }
    }
    return null;
  }
}

class OneToSixWithPlusMinusGradingSystem extends GradingSystem
    with EquatableMixin {
  @override
  IList<String> get possibleValues => const IListConst([
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
      ]);

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
    for (var val in possibleValues) {
      if (toDoubleOrThrow(val) == grade) {
        return val;
      }
    }
    return null;
  }
}
