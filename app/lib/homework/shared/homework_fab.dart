// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'open_homework_dialog.dart';

class HomeworkFab extends StatelessWidget {
  const HomeworkFab({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      icon: const Icon(Icons.add),
      tooltip: "Hausaufgabe hinzufügen",
      onPressed: () async {
        AnalyticsProvider.ofOrNullObject(context)
            .log(const AnalyticsEvent("homework_add_via_fab"));
        await openHomeworkDialogAndShowConfirmationIfSuccessful(context);
      },
      // When there are multiple FABs one has to have a different tag
      // than the other one. If none has a tag or both the same an error will be thrown
      heroTag: "sharezone-fab",
    );
  }
}
