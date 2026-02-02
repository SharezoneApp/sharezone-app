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

Future<bool> showSimpleStateDialog(
  BuildContext context,
  Future<bool> future,
) async {
  final stateContentStream = _mapFutureToStateContent(context, future);
  final stateDialog = StateDialog(stateContentStream);
  stateDialog.showDialogAutoPop(
    context,
    future: future,
    delay: const Duration(milliseconds: 350),
  );

  return future.then((value) {
    return Future.delayed(const Duration(milliseconds: 350)).then((_) => value);
  });
}

Stream<StateDialogContent> _mapFutureToStateContent(
  BuildContext context,
  Future<bool> future,
) {
  final stateContent = BehaviorSubject<StateDialogContent>.seeded(
    stateDialogContentLoading(context),
  );
  future.then((result) {
    if (!context.mounted) return;

    if (result == true) {
      stateContent.add(stateDialogContentSuccessful(context));
    } else {
      stateContent.add(stateDialogContentFailed(context));
    }
  });
  return stateContent;
}
