import 'package:sharezone/timetable/timetable_page/school_class_filter/school_class_filter_analytics.dart';

class MockSchoolClassFilterAnalytics implements SchoolClassFilterAnalytics {
  bool loggedSelectedASpecificSchoolClass = false;
  bool loggedSelectedToShowAllGroups = false;

  @override
  void logFilterBySchoolClass() {
    loggedSelectedASpecificSchoolClass = true;
  }

  @override
  void logShowAllGroups() {
    loggedSelectedToShowAllGroups = true;
  }
}
