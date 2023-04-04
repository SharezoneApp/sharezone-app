import 'package:user/user.dart';

class SubscriptionService {
  final Stream<AppUser> user;
  AppUser _user;

  SubscriptionService(this.user) {
    user.listen((event) {
      _user = event;
    });
  }

  bool hasFeatureUnlocked(PaidFeature feature) {
    return _user.subscription?.tier == SubscriptionTier.teacherPlus;
  }
}

enum PaidFeature {
  teacherSubmission,
}
