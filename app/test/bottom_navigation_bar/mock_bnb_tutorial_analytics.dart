// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_analytics.dart';

class MockBnbTutorialAnalytics implements BnbTutorialAnalytics {
  bool completedBnbTutorialLogged = false;
  bool skippedBnbTutorailLogged = false;

  @override
  void logCompletedBnbTutorial() {
    completedBnbTutorialLogged = true;
  }

  @override
  void logSkippedBnbTutorial() {
    skippedBnbTutorailLogged = true;
  }
}
