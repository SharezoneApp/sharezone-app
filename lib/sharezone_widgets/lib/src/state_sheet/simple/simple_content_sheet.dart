// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

StateSheetContent stateSheetContentLoading() =>
    const StateSheetContent(body: StateSheetLoadingBody());

StateSheetContent stateSheetContentSuccessful(BuildContext context) =>
    StateSheetContent.fromSimpleData(SimpleData.successful(context));

StateSheetContent stateSheetContentFailed(BuildContext context) =>
    StateSheetContent.fromSimpleData(SimpleData.failed(context));

StateSheetContent stateSheetContentUnknownException(BuildContext context) =>
    StateSheetContent.fromSimpleData(SimpleData.unkonwnException(context));

StateSheetContent stateSheetContentNoInternetException(BuildContext context) =>
    StateSheetContent.fromSimpleData(SimpleData.noInternet(context));
