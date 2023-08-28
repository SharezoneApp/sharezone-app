// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
  String toReadableString() {
    switch (this) {
      case NavigationExperimentOption.drawerAndBnb:
        return 'Aktuelle Navigation';
      case NavigationExperimentOption.extendableBnb:
        return 'Neue Navigation - Ohne Mehr-Button';
      case NavigationExperimentOption.extendableBnbWithMoreButton:
        return 'Neue Navigation - Mit Mehr-Button';
    }
  }
}
