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

class StateSheetContent {
  final Widget body;
  final List<ActionItem> actions;

  const StateSheetContent({@required this.body, this.actions = const []});

  factory StateSheetContent.fromSimpleData(SimpleData simpleData) {
    return StateSheetContent(
      body: StateSheetSimpleBody.fromSimpleData(simpleData: simpleData),
    );
  }
}
