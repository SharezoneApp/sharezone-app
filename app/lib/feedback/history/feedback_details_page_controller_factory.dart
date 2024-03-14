import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:sharezone/feedback/history/feedback_details_page_controller.dart';
import 'package:sharezone/feedback/shared/feedback_id.dart';
import 'package:sharezone/feedback/src/api/feedback_api.dart';

class FeedbackDetailsPageControllerFactory {
  final FeedbackApi feedbackApi;
  final UserId userId;
  final CrashAnalytics crashAnalytics;

  const FeedbackDetailsPageControllerFactory({
    required this.feedbackApi,
    required this.userId,
    required this.crashAnalytics,
  });

  FeedbackDetailsPageController create(FeedbackId feedbackId) {
    return FeedbackDetailsPageController(
      feedbackApi: feedbackApi,
      userId: userId,
      feedbackId: feedbackId,
      crashAnalytics: crashAnalytics,
    );
  }
}
