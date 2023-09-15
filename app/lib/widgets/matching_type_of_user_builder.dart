// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/user.dart';

/// If the current user matches [expectedTypeOfUser] [matchesTypeOfUserWidget]
/// is build else [notMatchingWidget] is build
class MatchingTypeOfUserBuilder extends StatelessWidget {
  const MatchingTypeOfUserBuilder({
    Key? key,
    required this.expectedTypeOfUser,
    required this.matchesTypeOfUserWidget,
    required this.notMatchingWidget,
  }) : super(key: key);

  final TypeOfUser expectedTypeOfUser;
  final Widget matchesTypeOfUserWidget;
  final Widget notMatchingWidget;

  @override
  Widget build(BuildContext context) {
    final typeOfUser = context.watch<TypeOfUser?>();
    return typeOfUser == expectedTypeOfUser
        ? matchesTypeOfUserWidget
        : notMatchingWidget;
  }
}
