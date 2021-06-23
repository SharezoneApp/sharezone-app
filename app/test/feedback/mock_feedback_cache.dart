
import 'package:sharezone/feedback/src/cache/feedback_cache.dart';

class MockFeedbackCache implements FeedbackCache {
  bool hasCooldown = true;

  @override
  Future<bool> hasFeedbackSubmissionCooldown(Duration feedbackCooldown) async {
    return hasCooldown;
  }

  @override
  Future<void> setLastSubmit() {
    return null;
  }

}