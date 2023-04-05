// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/helper_functions.dart';

enum SubscriptionTier {
  teacherPlus,
  unknown,
}

extension EnumByNameWithDefault<T extends Enum> on Iterable<T> {
  T tryByName(String name, {T? defaultValue}) {
    for (T value in this) {
      if (value.name == name) return value;
    }

    if (defaultValue != null) return defaultValue;
    throw ArgumentError.value(name, "name", "No enum value with that name");
  }
}

class Subscription {
  final SubscriptionTier tier;

  /// The date the user last purchased the subscription.
  ///
  /// If a new subscription is made this will be overridden. Shows only the
  /// latest subscription date.
  /// TODO: Is this initial purchase time or will this be updated every month?
  final DateTime purchasedAt;

  /// The date the latest user's subscription expires.
  final DateTime expiresAt;

  const Subscription(
    this.tier,
    this.purchasedAt,
    this.expiresAt,
  );

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'purchasedAt': purchasedAt,
      'expiresAt': expiresAt,
    };
  }

  static Subscription? fromData(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Subscription.fromJson(map);
  }

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return Subscription(
      SubscriptionTier.values.tryByName(
        map['tier'],
        defaultValue: SubscriptionTier.unknown,
      ),
      dateTimeFromTimestamp(map['purchasedAt']),
      dateTimeFromTimestamp(map['expiresAt']),
    );
  }

  @override
  String toString() =>
      'Subscription(tier: $tier, purchasedAt: $purchasedAt, expiresAt: $expiresAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.tier == tier &&
        other.purchasedAt == purchasedAt &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode => tier.hashCode ^ purchasedAt.hashCode ^ expiresAt.hashCode;
}
