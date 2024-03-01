// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_functions/cloud_functions.dart';
import 'package:user/user.dart';

class ChangeTypeOfUserRepository {
  final FirebaseFunctions _functions;

  const ChangeTypeOfUserRepository({
    required FirebaseFunctions functions,
  }) : _functions = functions;

  Future<void> changeTypeOfUser(TypeOfUser typeOfUser) async {
    final callable = _functions.httpsCallable('changeTypeOfUser');
    await callable.call({
      'type': typeOfUser.name,
    });
  }
}
