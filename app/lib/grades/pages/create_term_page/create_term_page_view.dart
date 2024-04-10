// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';

class CreateTermPageView extends Equatable {
  final String? name;
  final bool isActiveTerm;
  final String? nameErrorText;

  bool get isNameValid => nameErrorText == null;

  const CreateTermPageView({
    required this.name,
    required this.isActiveTerm,
    required this.nameErrorText,
  });

  @override
  List<Object?> get props => [name, isActiveTerm, nameErrorText];

  CreateTermPageView copyWith({
    String? name,
    bool? isActiveTerm,
    String? Function()? nameErrorText,
  }) {
    return CreateTermPageView(
      name: name ?? this.name,
      isActiveTerm: isActiveTerm ?? this.isActiveTerm,
      nameErrorText:
          nameErrorText != null ? nameErrorText() : this.nameErrorText,
    );
  }
}
