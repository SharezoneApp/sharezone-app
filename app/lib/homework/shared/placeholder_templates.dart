// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../homework_dialog/open_homework_dialog.dart';

class AddHomeworkCard extends StatelessWidget {
  const AddHomeworkCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListTile(
      leading: const Icon(Icons.add_circle_outline),
      centerTitle: true,
      title: const Text("Hausaufgabe eintragen"),
      onTap: () => openHomeworkDialogAndShowConfirmationIfSuccessful(context),
    );
  }
}
