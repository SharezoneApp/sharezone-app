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
import 'package:sharezone_widgets/state_sheet.dart';

Future<AppFunctionsResult<bool>> showAppFunctionStateSheet(BuildContext context,
    Future<AppFunctionsResult<bool>> appFunctionsResult) async {
  final stateContentStream = _mapAppFunctionToStateContent(appFunctionsResult);
  final stateSheet = StateSheet(stateContentStream);
  stateSheet.showSheetAutoPop(
    context,
    future: appFunctionsResult
        .then((result) => result.hasData && result.data == true),
    delay: Duration(milliseconds: 350),
  );

  return appFunctionsResult.then((value) {
    return Future.delayed(Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateSheetContent> _mapAppFunctionToStateContent(
    Future<AppFunctionsResult<bool>> appFunctionsResult) {
  final _stateContent =
      BehaviorSubject<StateSheetContent>.seeded(stateSheetContentLoading);
  appFunctionsResult.then((result) {
    if (result.hasData) {
      final boolean = result.data;
      if (boolean == true)
        _stateContent.add(stateSheetContentSuccessfull);
      else
        _stateContent.add(stateSheetContentFailed);
    } else {
      final exception = result.exception;
      if (exception is NoInternetAppFunctionsException)
        _stateContent.add(stateSheetContentNoInternetException);
      else
        _stateContent.add(stateSheetContentUnknownException);
    }
  });
  return _stateContent;
}
