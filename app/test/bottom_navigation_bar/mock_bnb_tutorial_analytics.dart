import 'package:sharezone/navigation/scaffold/portable/bottom_navigation_bar/tutorial/bnb_tutorial_analytics.dart';

class MockBnbTutorialAnalytics implements BnbTutorialAnalytics {
  bool completedBnbTutorialLogged = false;
  bool skippedBnbTutorailLogged = false;

  @override
  void logCompletedBnbTutorial() {
    completedBnbTutorialLogged = true;
  }

  @override
  void logSkippedBnbTutorial() {
    skippedBnbTutorailLogged = true;
  }
}
