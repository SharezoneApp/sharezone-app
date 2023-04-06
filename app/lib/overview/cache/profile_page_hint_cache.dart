// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/util/cache/streaming_key_value_store.dart';

const _showProfilePageHintSubjectKey = 'show-profile-page-hint123';

class ProfilePageHintCache {
  final bool isAnonymous;
  final StreamingKeyValueStore streamingCache;

  ProfilePageHintCache(this.isAnonymous, this.streamingCache);

  /// Show the profile page Hint only for anonymous user. The profile
  /// page hint is for anonymous user, to bring their to the profile
  /// page, where we explained, which disadvantages the anonymous user has.
  Stream<bool> get showProfilePageHint => streamingCache
      .getBool(_showProfilePageHintSubjectKey, defaultValue: true)
      .map((showProfilePageHinit) => isAnonymous && showProfilePageHinit);

  /// Sets the profile page hint as clicks. Next time the profile page hint
  /// will not displayed.
  void setProfilePageHintAsClicked() =>
      streamingCache.setBool(_showProfilePageHintSubjectKey, false);
}
