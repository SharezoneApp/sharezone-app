// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum NavigationExperimentOption {
  /// Current Navigation (Drawer + BNB)
  drawerAndBnb,

  /// ExtendableBottomNavigationBar (5 [NavigationItem], without more-button)
  extendableBnb,

  /// ExtendableBottomNavigationBar (4 [NavigationItem] + 1 more-button, to expand the
  /// navigation)
  extendableBnbWithMoreButton,
}

extension ToReadableString on NavigationExperimentOption {
  String toLocalizedString(BuildContext context) {
    return switch (this) {
      NavigationExperimentOption.drawerAndBnb =>
        context.l10n.navigationExperimentOptionDrawerAndBnb,
      NavigationExperimentOption.extendableBnb =>
        context.l10n.navigationExperimentOptionExtendableBnb,
      NavigationExperimentOption.extendableBnbWithMoreButton =>
        context.l10n.navigationExperimentOptionExtendableBnbWithMoreButton,
    };
  }
}
