// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/change_data_bloc.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_email.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:build_context/build_context.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum ChangeType { email, password }

Future<void> submit(
  BuildContext context,
  String snackBarText,
  ChangeType changeType,
) async {
  final bloc = BlocProvider.of<ChangeDataBloc>(context);
  showSnackSec(
    context: context,
    withLoadingCircle: true,
    seconds: 10,
    text: snackBarText,
    behavior: SnackBarBehavior.fixed,
  );

  try {
    if (changeType == ChangeType.email) {
      await bloc.submitEmail();
      if (!context.mounted) return;
      context.hideCurrentSnackBar();
      VerifyEmailAddressDialog.show(context);
    } else {
      await bloc.submitPassword();
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }
  } on IdenticalEmailException catch (_) {
    if (!context.mounted) return;
    showSnackSec(
      text: context.l10n.changeEmailAddressIdenticalError,
      context: context,
      behavior: SnackBarBehavior.fixed,
    );
  } on Exception catch (e, s) {
    if (!context.mounted) return;
    showSnackSec(
      text: handleErrorMessage(l10n: context.l10n, error: e, stackTrace: s),
      behavior: SnackBarBehavior.fixed,
      context: context,
    );
  }
}
