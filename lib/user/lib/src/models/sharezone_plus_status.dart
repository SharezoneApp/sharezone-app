// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:helper_functions/helper_functions.dart';

class SharezonePlusStatus {
  /// Whether the user has Sharezone Plus.
  final bool hasPlus;

  /// Whether the subscription is cancelled.
  final bool isCancelled;

  /// The source where the subscription was purchased.
  ///
  /// If `null` the user might have the lifetime option.
  final SubscriptionSource? source;

  /// Whether the user has a lifetime subscription.
  final bool hasLifetime;

  const SharezonePlusStatus({
    required this.hasPlus,
    required this.isCancelled,
    required this.source,
    required this.hasLifetime,
  });

  static SharezonePlusStatus? fromData(Map<String, dynamic>? map) {
    if (map == null) return null;
    return SharezonePlusStatus.fromJson(map);
  }

  factory SharezonePlusStatus.fromJson(Map<String, dynamic> map) {
    return SharezonePlusStatus(
      hasPlus: map['hasPlus'] ?? false,
      isCancelled: map['isCancelled'] ?? false,
      source: parseSource(map['subscriptionDetails']),
      hasLifetime: map['period'] == 'lifetime',
    );
  }

  static SubscriptionSource? parseSource(
      Map<String, dynamic>? subscriptionDetails) {
    if (subscriptionDetails == null) return null;
    return SubscriptionSource.values.tryByName(
      subscriptionDetails['source'],
      defaultValue: SubscriptionSource.unknown,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SharezonePlusStatus &&
        other.hasPlus == hasPlus &&
        other.isCancelled == isCancelled &&
        other.source == source &&
        other.hasLifetime == hasLifetime;
  }

  @override
  int get hashCode {
    return hasPlus.hashCode ^
        isCancelled.hashCode ^
        source.hashCode ^
        hasLifetime.hashCode;
  }
}

enum SubscriptionSource {
  playStore('Play Store'),
  appStore('App Store'),
  stripe('Stripe'),
  unknown('Unknown');

  const SubscriptionSource(this.uiString);

  final String uiString;
}
