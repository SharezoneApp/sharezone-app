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
  final DateTime lastSubscribedAt;

  const Subscription(this.tier, this.lastSubscribedAt);

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'lastSubscribedAt': lastSubscribedAt,
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
      dateTimeFromTimestamp(map['lastSubscribedAt']),
    );
  }

  @override
  String toString() =>
      'Subscription(tier: $tier, lastSubscribedAt: $lastSubscribedAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.tier == tier &&
        other.lastSubscribedAt == lastSubscribedAt;
  }

  @override
  int get hashCode => Object.hash(tier, lastSubscribedAt);
}
