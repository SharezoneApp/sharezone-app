// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class CreateTermPageView extends Equatable {
  final String? name;
  final bool isActiveTerm;
  final GradingSystem gradingSystem;
  final String? nameErrorText;

  bool get isNameValid => nameErrorText == null;

  const CreateTermPageView({
    required this.name,
    required this.isActiveTerm,
    required this.nameErrorText,
    required this.gradingSystem,
  });

  @override
  List<Object?> get props => [name, isActiveTerm, nameErrorText];

  CreateTermPageView copyWith({
    String? name,
    bool? isActiveTerm,
    String? Function()? nameErrorText,
    GradingSystem? gradingSystem,
  }) {
    return CreateTermPageView(
      name: name ?? this.name,
      isActiveTerm: isActiveTerm ?? this.isActiveTerm,
      nameErrorText:
          nameErrorText != null ? nameErrorText() : this.nameErrorText,
      gradingSystem: gradingSystem ?? this.gradingSystem,
    );
  }
}
