// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';

class SharezoneDrawerController extends BlocBase {
  final bool isDesktopModus;

  SharezoneDrawerController(this.isDesktopModus);

  @override
  void dispose() {}
}
