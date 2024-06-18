// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'advanceable_homework_loader.dart';
import 'realtime_updating_lazy_loading_controller.dart';

class RealtimeUpdatingLazyLoadingControllerFactory<
    T extends BaseHomeworkReadModel> {
  final AdvanceableHomeworkLoader<T> _homeworkLoader;

  RealtimeUpdatingLazyLoadingControllerFactory(this._homeworkLoader);

  RealtimeUpdatingLazyLoadingController<T> create(
      int initialNumberOfHomeworksToLoad) {
    return RealtimeUpdatingLazyLoadingController<T>(_homeworkLoader,
        initialNumberOfHomeworksToLoad: initialNumberOfHomeworksToLoad);
  }
}
