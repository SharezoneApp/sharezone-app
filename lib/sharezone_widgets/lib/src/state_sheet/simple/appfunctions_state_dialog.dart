import 'package:app_functions/app_functions.dart';
import 'package:app_functions/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_widgets/state_sheet.dart';

Future<AppFunctionsResult<bool>> showAppFunctionStateDialog(
    BuildContext context,
    Future<AppFunctionsResult<bool>> appFunctionsResult) async {
  final stateContentStream = _mapAppFunctionToStateContent(appFunctionsResult);
  final stateDialog = StateDialog(stateContentStream);
  stateDialog.showDialogAutoPop(
    context,
    future: appFunctionsResult
        .then((result) => result.hasData && result.data == true),
    delay: const Duration(milliseconds: 350),
  );

  return appFunctionsResult.then((value) {
    return Future.delayed(Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateDialogContent> _mapAppFunctionToStateContent(
    Future<AppFunctionsResult<bool>> appFunctionsResult) {
  final _stateContent =
      BehaviorSubject<StateDialogContent>.seeded(stateDialogContentLoading);
  appFunctionsResult.then((result) {
    if (result.hasData) {
      final boolean = result.data;
      if (boolean == true)
        _stateContent.add(stateDialogContentSuccessfull);
      else
        _stateContent.add(stateDialogContentFailed);
    } else {
      final exception = result.exception;
      if (exception is NoInternetAppFunctionsException)
        _stateContent.add(stateDialogContentNoInternetException);
      else
        _stateContent.add(stateDialogContentUnknownException);
    }
  });
  return _stateContent;
}
