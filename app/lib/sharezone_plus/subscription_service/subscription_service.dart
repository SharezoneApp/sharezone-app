import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser> user;
  final Clock clock;
  AppUser _user;

  SubscriptionService({
    @required this.user,
    @required this.clock,
  }) {
    user.listen((event) {
      _user = event;
    });
  }

  bool isSubscriptionActive() {
    if (_user.subscription == null) return false;
    return _user.subscription.expiresAt.isAfter(clock.now());
  }

  bool hasFeatureUnlocked(PaidFeature feature) {
    if (!isSubscriptionActive()) return false;
    return _user.subscription?.tier == SubscriptionTier.teacherPlus;
  }
}

enum PaidFeature {
  teacherSubmission,
}
