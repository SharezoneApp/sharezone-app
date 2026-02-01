// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<bool> showSimpleStateSheet(
  BuildContext context,
  Future<bool> future,
) async {
  final stateContentStream = _mapFutureToStateContent(context, future);
  final stateDialog = StateSheet(stateContentStream);
  stateDialog.showSheet(context);

  return future.then((value) {
    return Future.delayed(const Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateSheetContent> _mapFutureToStateContent(
  BuildContext context,
  Future<bool> future,
) {
  final stateContent = BehaviorSubject<StateSheetContent>.seeded(
    stateSheetContentLoading(),
  );
  future.then((result) {
    if (result == true) {
      stateContent.add(stateSheetContentSuccessfull(context));
    } else {
      stateContent.add(stateSheetContentFailed(context));
    }
  });
  return stateContent;
}
