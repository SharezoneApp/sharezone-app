// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/activation_code/src/models/enter_activation_code_result.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FailedEnterActivationCodeResultDialog extends StatelessWidget {
  final FailedEnterActivationCodeResult failedEnterActivationCodeResult;

  const FailedEnterActivationCodeResultDialog({
    super.key,
    required this.failedEnterActivationCodeResult,
  });
  @override
  Widget build(BuildContext context) {
    if (failedEnterActivationCodeResult.enterActivationCodeException
        is NoInternetEnterActivationCodeException) {
      return _NoInternet();
    }
    if (failedEnterActivationCodeResult.enterActivationCodeException
        is NotAvailableEnterActivationCodeException) {
      return _NotAvailable();
    }
    if (failedEnterActivationCodeResult.enterActivationCodeException
        is NotFoundEnterActivationCodeException) {
      return _NotFound();
    }

    return _UnknownError();
  }
}

class _UnknownError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.activationCodeErrorUnknownTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.activationCodeErrorUnknownDescription,
    );
  }
}

class _NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.activationCodeErrorNoInternetTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.activationCodeErrorNoInternetDescription,
    );
  }
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.activationCodeErrorInvalidTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.activationCodeErrorInvalidDescription,
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.activationCodeErrorNotFoundTitle,
      iconData: Icons.error,
      iconColor: Colors.red,
      description: context.l10n.activationCodeErrorNotFoundDescription,
    );
  }
}
