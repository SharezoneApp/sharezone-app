// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_widgets/state_sheet.dart';

Future<bool> showSimpleStateDialog(
    BuildContext context, Future<bool> future) async {
  final stateContentStream = _mapFutureToStateContent(future);
  final stateDialog = StateDialog(stateContentStream);
  stateDialog.showDialogAutoPop(
    context,
    future: future,
    delay: Duration(milliseconds: 350),
  );

  return future.then((value) {
    return Future.delayed(Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateDialogContent> _mapFutureToStateContent(Future<bool> future) {
  final _stateContent =
      BehaviorSubject<StateDialogContent>.seeded(stateDialogContentLoading);
  future.then((result) {
    if (result == true)
      _stateContent.add(stateDialogContentSuccessfull);
    else
      _stateContent.add(stateDialogContentFailed);
  });
  return _stateContent;
}
