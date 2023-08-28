// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/pages/settings/changelog/change_view.dart';

class ChangelogPageView {
  final List<ChangeView> changes;
  final bool userHasNewestVersion;
  final bool allChangesLoaded;
  bool get hasChanges => changes.isNotEmpty;

  const ChangelogPageView({
    required this.changes,
    this.userHasNewestVersion = true,
    this.allChangesLoaded = false,
  });

  const ChangelogPageView.placeholder()
      : changes = const [],
        userHasNewestVersion = true,
        allChangesLoaded = false;
}
