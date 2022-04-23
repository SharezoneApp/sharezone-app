// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_analytics.dart';

import 'bnb_tutorial_cache.dart';

class BnbTutorialBloc extends BlocBase {
  final BnbTutorialCache _cache;
  final BnbTutorialAnalytics _analytics;

  /// BnbTutorial should only be displayed after the onboaridng is finished.
  final Stream<bool> isGroupOnboardingFinsihed;

  /// See documantion in [setTutorialAsShown()]
  bool _alreadyShowedInRuntime = false;

  BnbTutorialBloc(this._cache, this._analytics, this.isGroupOnboardingFinsihed);

  Stream<bool> shouldShowBnbTutorial() {
    return isGroupOnboardingFinsihed.map((event) =>
        event && !_cache.wasTutorialCompleted() && !_alreadyShowedInRuntime);
  }

  /// Saves in runtime that BnbTutorial already showed. If a user would rotate
  /// his phone or opens e. g. the group page, BnbTutorial would show again
  /// (twice on top of each other). [_alreadyShowedInRuntime] will prevent this.
  /// The advantage of saving this in runtime (and not in cache) is that the
  /// tutorial is displayed again when the app is restarted --> user must
  /// finish/skip the tutorial
  void setTutorialAsShown() {
    _alreadyShowedInRuntime = true;
  }

  void markTutorialAsCompleted() {
    _cache.setTutorialAsCompleted();
    _analytics.logCompletedBnbTutorial();
  }

  void markTutorialAsSkipped() {
    _cache.setTutorialAsCompleted();
    _analytics.logSkippedBnbTutorial();
  }

  @override
  void dispose() {}
}
