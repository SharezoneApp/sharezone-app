// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:user/user.dart';

/// If the current user matches [expectedTypeOfUser] [matchesTypeOfUserWidget] is build
/// else [notMatchingWidget] is build
class MatchingTypeOfUserStreamBuilder extends StatelessWidget {
  final TypeOfUser expectedTypeOfUser;
  final Widget matchesTypeOfUserWidget;
  final Widget notMatchingWidget;

  const MatchingTypeOfUserStreamBuilder({
    Key? key,
    required this.expectedTypeOfUser,
    required this.matchesTypeOfUserWidget,
    required this.notMatchingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return StreamBuilder<AppUser>(
      stream: api.user.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.typeOfUser == expectedTypeOfUser)
          return matchesTypeOfUserWidget;
        return notMatchingWidget;
      },
    );
  }
}
