// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_widgets/sharezone_widgets.dart';

const stateDialogContentLoading = StateDialogContent(
  title: 'Bitte warten...',
  body: StateDialogLoadingBody(),
);

final stateDialogContentSuccessfull =
    StateDialogContent.fromSimpleData(SimpleData.successful());

final stateDialogContentFailed =
    StateDialogContent.fromSimpleData(SimpleData.failed());

final stateDialogContentUnknownException =
    StateDialogContent.fromSimpleData(SimpleData.unkonwnException());

final stateDialogContentNoInternetException =
    StateDialogContent.fromSimpleData(SimpleData.noInternet());
