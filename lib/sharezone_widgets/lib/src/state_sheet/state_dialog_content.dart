// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/common_widgets.dart';
import 'package:sharezone_widgets/state_sheet.dart';

class StateDialogContent {
  final String title;
  final Widget body;
  final List<ActionItem> actions;

  const StateDialogContent(
      {@required this.title, @required this.body, this.actions = const []});

  factory StateDialogContent.fromSimpleData(SimpleData simpleData) {
    return StateDialogContent(
      title: simpleData.title,
      body: StateDialogSimpleBody.fromSimpleData(simpleData: simpleData),
    );
  }
}
