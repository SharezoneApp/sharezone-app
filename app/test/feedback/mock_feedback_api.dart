import 'package:sharezone/feedback/src/api/feedback_api.dart';
import 'package:sharezone/feedback/src/models/user_feedback.dart';

class MockFeedbackApi extends FeedbackApi {
  bool get wasInvoked => invocations.isNotEmpty;

  List<UserFeedback> invocations = [];

  bool wasOnlyInvokedWith(UserFeedback feedback) {
    return invocations.single == feedback;
  }

  @override
  Future<void> sendFeedback(UserFeedback feedback) {
    invocations.add(feedback);
    return null;
  }
}