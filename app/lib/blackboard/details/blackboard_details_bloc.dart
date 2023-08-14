// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/blackboard/blackboard_view.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/course_gateway.dart';

class BlackboardDetailsBloc extends BlocBase {
  final BlackboardGateway gateway;
  final String itemID, uid;
  final Stream<BlackboardView> view;

  BlackboardDetailsBloc(
      this.gateway, this.itemID, this.uid, CourseGateway courseGateway)
      : view = gateway.singleBlackboardItem(itemID).map((item) =>
            BlackboardView.fromBlackboardItem(item, uid, courseGateway));

  void changeReadStatus(bool newValue) =>
      gateway.changeIsBlackboardDoneTo(itemID, newValue);

  @override
  void dispose() {}
}
