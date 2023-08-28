// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:sharezone/activation_code/src/models/enter_activation_code_result.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SuccessfulEnterActivationCodeResultDialog extends StatelessWidget {
  const SuccessfulEnterActivationCodeResultDialog({
    Key? key,
    required this.result,
  }) : super(key: key);

  final SuccessfullEnterActivationCodeResult result;

  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
        title: "Erfolgreich aktiviert: ${result.codeName} 🎉",
        iconData: Icons.done,
        iconColor: Colors.green,
        description: result.codeDescription);
  }
}
