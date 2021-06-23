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
    throw UnimplementedError('No readable string for $this found');
  }
}