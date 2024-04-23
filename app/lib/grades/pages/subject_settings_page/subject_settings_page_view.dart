// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class SubjectSettingsPageView extends Equatable {
  final String subjectName;
  final String finalGradeTypeDisplayName;
  final Icon finalGradeTypeIcon;
  final IList<GradeType> selectableGradingTypes;
  final IMap<GradeTypeId, Weight> weights;

  const SubjectSettingsPageView({
    required this.subjectName,
    required this.finalGradeTypeDisplayName,
    required this.finalGradeTypeIcon,
    required this.selectableGradingTypes,
    required this.weights,
  });

  @override
  List<Object?> get props => [
        subjectName,
        finalGradeTypeDisplayName,
        finalGradeTypeIcon,
        selectableGradingTypes,
      ];
}
