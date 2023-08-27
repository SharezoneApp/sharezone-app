// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/util/api/blackboard_api.dart';

class BlackboardCardBloc extends BlocBase {
  final BlackboardGateway gateway;
  final String itemID;

  BlackboardCardBloc({
    required this.gateway,
    required this.itemID,
  });

  void changeReadState(bool newState) =>
      gateway.changeIsBlackboardDoneTo(itemID, newState);

  @override
  void dispose() {}
}
