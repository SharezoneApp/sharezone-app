// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';

class MissingAccountInformationGuardBloc extends BlocBase {
  final UserGateway userGateway;

  final Stream<bool> hasUserSharezoneAccount;

  MissingAccountInformationGuardBloc(this.userGateway)
      : hasUserSharezoneAccount =
            userGateway.userDocument.map((doc) => doc.exists);

  Future<void> logOut() => userGateway.logOut();

  @override
  void dispose() {}
}
