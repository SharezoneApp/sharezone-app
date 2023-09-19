// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';

void main() {
  group("FeedbackCache", () {
    late FeedbackCache cache;
    late InMemoryKeyValueStore dummyKeyValueStore;

    setUp(() async {
      dummyKeyValueStore = InMemoryKeyValueStore();
      cache = FeedbackCache(dummyKeyValueStore);
    });

    test("Returns no Cooldown if no last submit was saved", () async {
      final onCooldown =
          await cache.hasFeedbackSubmissionCoolDown(const Duration(minutes: 1));
      expect(onCooldown, false);
    });
    test(
        "Returns no cooldown if cached last send time is more than cooldown range",
        () async {
      const cooldownDuration = Duration(minutes: 2);
      final lastFeedbackSend = DateTime.now().subtract(cooldownDuration +
          const Duration(seconds: 10)); // So Feedback should get no cooldown

      dummyKeyValueStore.setString(
          FeedbackCache.lastSubmitCacheKey, lastFeedbackSend.toString());

      final onCooldown =
          await cache.hasFeedbackSubmissionCoolDown(cooldownDuration);
      expect(onCooldown, false);
    });

    test(
        "Returns cooldown if cached last send time is less than cooldown range",
        () async {
      const cooldownDuration = Duration(minutes: 2);
      final lastFeedbackSend = DateTime.now().subtract(cooldownDuration -
          const Duration(seconds: 10)); // So Feedback should get cooldown

      await dummyKeyValueStore.setString(
          FeedbackCache.lastSubmitCacheKey, lastFeedbackSend.toString());

      final onCooldown =
          await cache.hasFeedbackSubmissionCoolDown(cooldownDuration);
      expect(onCooldown, true);
    });
  });
}
