// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:key_value_store/key_value_store.dart';
import 'package:sharezone/calendrical_events/models/calendrical_events_layout.dart';
import 'package:sharezone_common/helper_functions.dart';

class CalendricalEventsPageCache {
  final KeyValueStore keyValueStore;
  static const _layoutKey = 'calendrical-events-page-layout';

  const CalendricalEventsPageCache(this.keyValueStore);

  CalendricalEventsPageLayout? getLayout() {
    final layoutString = keyValueStore.getString(_layoutKey);
    return CalendricalEventsPageLayout.values.byNameOrNull(layoutString);
  }

  Future<bool> setLayout(CalendricalEventsPageLayout layout) {
    return keyValueStore.setString(_layoutKey, layout.name);
  }
}
