import 'package:flutter/material.dart';

import 'package:sharezone_widgets/state_sheet.dart';
import 'package:sharezone_widgets/theme.dart';

import 'bloc/enter_activation_code_bloc.dart';
import 'models/enter_activation_code_result.dart';
import 'widgets/failed_result_dialog.dart';
import 'widgets/loading_result_dialog.dart';
import 'widgets/successful_result_dialog.dart';

class EnterActivationCodeResultDialog {
  final EnterActivationCodeBloc enterActivationCodeBloc;

  EnterActivationCodeResultDialog(this.enterActivationCodeBloc);

  StateSheetContent mapStateSheetContentFromJoinResult(
    EnterActivationCodeResult enterActivationCodeResult,
    BuildContext context,
  ) {
    if (enterActivationCodeResult is SuccessfullEnterActivationCodeResult)
      return StateSheetContent(
        body: SuccessfulEnterActivationCodeResultDialog(
            result: enterActivationCodeResult),
        actions: [
          ActionItem(
            title: "Fertig",
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onSelect: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      );

    if (enterActivationCodeResult is FailedEnterActivationCodeResult)
      return StateSheetContent(
        body: FailedEnterActivationCodeResultDialog(
            failedEnterActivationCodeResult: enterActivationCodeResult),
        actions: [
          ActionItem(
            title: "Nochmal versuchen",
            onSelect: () => enterActivationCodeBloc.retry(),
          ),
        ],
      );

    return StateSheetContent(body: LoadingEnterActivationCodeResultDialog());
  }

  Future<void> show(BuildContext context) {
    hideKeyboard(context: context);
    final joinResultStream = enterActivationCodeBloc.enterActivationCodeResult;
    final stateSheetContentStream = joinResultStream.map((joinResult) =>
        mapStateSheetContentFromJoinResult(joinResult, context));
    final stateSheet = StateSheet(stateSheetContentStream);

    return stateSheet.showSheet(context);
  }
}
