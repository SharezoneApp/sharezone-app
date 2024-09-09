// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class TermSettingsPageView extends Equatable {
  final String name;
  final bool isActiveTerm;
  final GradingSystem gradingSystem;
  final GradeType finalGradeType;
  final IList<GradeType> selectableGradingTypes;
  final IMap<GradeTypeId, Weight> weights;
  final IList<SubjectView> subjects;
  final WeightDisplayType weightDisplayType;

  const TermSettingsPageView({
    required this.name,
    required this.isActiveTerm,
    required this.gradingSystem,
    required this.finalGradeType,
    required this.selectableGradingTypes,
    required this.weights,
    required this.subjects,
    required this.weightDisplayType,
  });

  @override
  List<Object?> get props => [
        name,
        isActiveTerm,
        gradingSystem,
        finalGradeType,
        selectableGradingTypes,
        weights,
        subjects,
        weightDisplayType,
      ];
}

typedef SubjectView = ({
  SubjectId id,
  Design design,
  String abbreviation,
  String displayName,
  Weight weight,
});
