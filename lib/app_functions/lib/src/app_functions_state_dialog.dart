// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:app_functions/app_functions.dart';
import 'package:app_functions/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<AppFunctionsResult<bool>> showAppFunctionStateDialog(
  BuildContext context,
  Future<AppFunctionsResult<bool>> appFunctionsResult,
) async {
  final stateContentStream = _mapAppFunctionToStateContent(
    context,
    appFunctionsResult,
  );
  final stateDialog = StateDialog(stateContentStream);
  stateDialog.showDialogAutoPop(
    context,
    future: appFunctionsResult.then(
      (result) => result.hasData && result.data == true,
    ),
    delay: const Duration(milliseconds: 350),
  );

  return appFunctionsResult.then((value) {
    return Future.delayed(const Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateDialogContent> _mapAppFunctionToStateContent(
  BuildContext context,
  Future<AppFunctionsResult<bool>> appFunctionsResult,
) {
  final stateContent = BehaviorSubject<StateDialogContent>.seeded(
    stateDialogContentLoading(context),
  );
  appFunctionsResult.then((result) {
    if (result.hasData) {
      final boolean = result.data;
      if (boolean == true) {
        stateContent.add(stateDialogContentSuccessfull(context));
      } else {
        stateContent.add(stateDialogContentFailed(context));
      }
    } else {
      final exception = result.exception;
      if (exception is NoInternetAppFunctionsException) {
        stateContent.add(stateDialogContentNoInternetException(context));
      } else {
        stateContent.add(stateDialogContentUnknownException(context));
      }
    }
  });
  return stateContent;
}
