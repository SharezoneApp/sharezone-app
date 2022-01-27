// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone_utils/streams.dart';

import 'user_view.dart';

class MyProfileBloc extends BlocBase {
  final Stream<UserView> userViewStream;

  MyProfileBloc(UserGateway userGateway)
      : userViewStream = TwoStreams(
                userGateway.userStream, userGateway.authUserStream)
            .stream
            .map((result) =>
                UserView.fromUserAndFirebaseUser(result.data0, result.data1));

  @override
  void dispose() {}
}
