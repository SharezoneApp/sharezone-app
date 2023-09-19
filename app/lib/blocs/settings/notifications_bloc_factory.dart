// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/blocs/settings/notifications_bloc.dart';
import 'package:sharezone/util/api/user_api.dart';

class NotificationsBlocFactory extends BlocBase {
  final UserGateway _userGateway;

  NotificationsBlocFactory(this._userGateway);

  NotificationsBloc create() {
    return NotificationsBloc(_userGateway);
  }

  @override
  void dispose() {}
}
