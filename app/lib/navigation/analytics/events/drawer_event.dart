// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';

import 'navigation_event.dart';

class DrawerEvent extends NavigationEvent {
  DrawerEvent(String name)
      : assert(isNotEmptyOrNull(name)),
        super("drawer_$name");
}
