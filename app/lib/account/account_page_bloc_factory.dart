// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification_gateways.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/account_page_bloc.dart';
import 'package:sharezone/util/api/user_api.dart';

class AccountPageBlocFactory extends BlocBase {
  final UserGateway _userGateway;

  AccountPageBlocFactory(this._userGateway);

  AccountPageBloc create(
      GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
    return AccountPageBloc(
      globalKey: scaffoldMessengerKey,
      linkProviderGateway: LinkProviderGateway(_userGateway),
      userGateway: _userGateway,
    );
  }

  @override
  void dispose() {}
}
