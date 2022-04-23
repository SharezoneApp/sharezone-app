// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/navigation/analytics/events/navigation_event.dart';
import 'package:sharezone_common/helper_functions.dart';

class NavBottomBar extends NavigationEvent {
  NavBottomBar(String name)
      : assert(isNotEmptyOrNull(name)),
        super("nav_bottom_bar_$name");
}
