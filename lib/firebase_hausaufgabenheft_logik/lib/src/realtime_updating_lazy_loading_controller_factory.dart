// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'realtime_completed_homework_loader.dart';
import 'realtime_updating_lazy_loading_controller.dart';

class RealtimeUpdatingLazyLoadingControllerFactory {
  final RealtimeCompletedHomeworkLoader _homeworkLoader;

  RealtimeUpdatingLazyLoadingControllerFactory(this._homeworkLoader);

  RealtimeUpdatingLazyLoadingController create(
      int initialNumberOfHomeworksToLoad) {
    return RealtimeUpdatingLazyLoadingController(_homeworkLoader,
        initialNumberOfHomeworksToLoad: initialNumberOfHomeworksToLoad);
  }
}
