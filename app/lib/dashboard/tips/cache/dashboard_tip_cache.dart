// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const dashboardCounterKey = "dashboard-counter";

class DashboardTipCache {
  final StreamingKeyValueStore streamingCache;

  DashboardTipCache(this.streamingCache);

  Future<void> increaseDashboardCounter() async {
    final counter = await getDashboardCounter().first;
    streamingCache.setInt(dashboardCounterKey, counter + 1);
  }

  void markTipAsShown(String key) {
    streamingCache.setBool(key, true);
  }

  Stream<int> getDashboardCounter() {
    return streamingCache.getInt(dashboardCounterKey, defaultValue: 0);
  }

  Stream<bool> showedTip(String key) {
    return streamingCache.getBool(key, defaultValue: false);
  }
}
