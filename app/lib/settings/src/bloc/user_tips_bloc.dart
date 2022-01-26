// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:user/user.dart';

class UserTipsBloc extends BlocBase {
  final UserGateway _userGateway;

  UserTipsBloc(this._userGateway);

  Stream<UserTipData> streamUserTipData() {
    return _userGateway.userStream.map((user) => user?.userTipData);
  }

  void enableUserTip(UserTipKey tipKey) {
    _updateUserTip(tipKey, true);
  }

  void _updateUserTip(UserTipKey tipKey, bool newValue) {
    _userGateway.updateUserTip(tipKey, newValue);
  }

  @override
  void dispose() {}
}
