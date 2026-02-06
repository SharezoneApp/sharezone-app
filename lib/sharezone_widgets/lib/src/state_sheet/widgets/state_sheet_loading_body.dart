// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class StateSheetLoadingBody extends StatelessWidget {
  const StateSheetLoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        const SizedBox(
          width: 35,
          height: 35,
          child: AccentColorCircularProgressIndicator(),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.sharezoneWidgetsLoadingEncryptedTransfer,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
