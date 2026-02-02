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

StateDialogContent stateDialogContentLoading(BuildContext context) =>
    StateDialogContent(
      title: context.l10n.commonLoadingPleaseWait,
      body: const StateDialogLoadingBody(),
    );

StateDialogContent stateDialogContentSuccessful(BuildContext context) =>
    StateDialogContent.fromSimpleData(SimpleData.successful(context));

StateDialogContent stateDialogContentFailed(BuildContext context) =>
    StateDialogContent.fromSimpleData(SimpleData.failed(context));

StateDialogContent stateDialogContentUnknownException(BuildContext context) =>
    StateDialogContent.fromSimpleData(SimpleData.unkonwnException(context));

StateDialogContent stateDialogContentNoInternetException(
  BuildContext context,
) => StateDialogContent.fromSimpleData(SimpleData.noInternet(context));
