import 'package:flutter/material.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_widgets/state_sheet.dart';

class SuccessfulJoinResultDialog extends StatelessWidget {
  final SuccessfullJoinResult result;

  const SuccessfulJoinResultDialog({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: "Erfolgreich beigetreten 🎉",
      iconData: Icons.done,
      iconColor: Colors.green,
      description:
          "${result.groupInfo.name} wurde erfolgreich hinzugefügt. Du bist nun Mitglied.",
    );
  }
}
