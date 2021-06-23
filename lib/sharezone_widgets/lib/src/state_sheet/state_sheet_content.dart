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
