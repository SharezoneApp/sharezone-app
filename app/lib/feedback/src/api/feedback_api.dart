
import 'package:sharezone/feedback/src/models/user_feedback.dart';

// ignore: one_member_abstracts
abstract class FeedbackApi {
  Future<void> sendFeedback(UserFeedback feedback);
}
