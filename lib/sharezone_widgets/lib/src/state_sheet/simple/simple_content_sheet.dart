// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_widgets/sharezone_widgets.dart';

const stateSheetContentLoading = StateSheetContent(
  body: StateSheetLoadingBody(),
);

final stateSheetContentSuccessfull =
    StateSheetContent.fromSimpleData(SimpleData.successful());

final stateSheetContentFailed =
    StateSheetContent.fromSimpleData(SimpleData.failed());

final stateSheetContentUnknownException =
    StateSheetContent.fromSimpleData(SimpleData.unkonwnException());

final stateSheetContentNoInternetException =
    StateSheetContent.fromSimpleData(SimpleData.noInternet());
