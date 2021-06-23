import 'package:flutter/material.dart';
import 'package:sharezone/activation_code/src/models/enter_activation_code_result.dart';
import 'package:sharezone_widgets/state_sheet.dart';

class SuccessfulEnterActivationCodeResultDialog extends StatelessWidget {
  final SuccessfullEnterActivationCodeResult result;

  const SuccessfulEnterActivationCodeResultDialog({Key key, this.result})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
        title: "Erfolgreich aktiviert: ${result.codeName} 🎉",
        iconData: Icons.done,
        iconColor: Colors.green,
        description: result.codeDescription);
  }
}
