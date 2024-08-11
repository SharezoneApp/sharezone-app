// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';

import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> openHomeworkDialogAndShowConfirmationIfSuccessful(
  BuildContext context, {
  HomeworkDto? homework,
}) async {
  final successful = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => HomeworkDialog(
        id: homework?.id != null ? HomeworkId(homework!.id) : null,
      ),
      settings: const RouteSettings(name: HomeworkDialog.tag),
    ),
  );
  if (successful == true && context.mounted) {
    await _showUserConfirmationOfHomeworkArrival(context: context);
  }
}

Future<void> _showUserConfirmationOfHomeworkArrival({
  required BuildContext context,
}) async {
  await waitingForPopAnimation();
  if (!context.mounted) return;
  showDataArrivalConfirmedSnackbar(context: context);
}
