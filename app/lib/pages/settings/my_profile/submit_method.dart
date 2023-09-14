// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/settings/change_data_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

enum ChangeType {
  email,
  password,
}

Future<void> submit(
    BuildContext context, String snackBarText, ChangeType changeType) async {
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
    } else {
      await bloc.submitPassword();
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }
  } on IdenticalEmailException catch (e) {
    if (!context.mounted) return;
    showSnackSec(
      text: e.message,
      context: context,
      behavior: SnackBarBehavior.fixed,
    );
  } on Exception catch (e, s) {
    if (!context.mounted) return;
    showSnackSec(
      text: handleErrorMessage(e.toString(), s),
      behavior: SnackBarBehavior.fixed,
      context: context,
    );
  }
}
