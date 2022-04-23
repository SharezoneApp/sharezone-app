// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/signed_up_bloc.dart';
import 'package:user/user.dart';

class RegistrationBloc extends BlocBase {
  final RegistrationGateway _gateway;
  final SignUpBloc _signUpBloc;

  TypeOfUser typeOfUser;

  RegistrationBloc(this._gateway, this._signUpBloc);

  Function(TypeOfUser) get setTypeOfUser => (userType) => typeOfUser = userType;

  Future<void> signUp() async {
    _signUpBloc.setTypeOfUser(typeOfUser);
    _signUpBloc.setSignedUp(true);
    await _gateway.registerUser(typeOfUser);
  }

  @override
  void dispose() {}
}
