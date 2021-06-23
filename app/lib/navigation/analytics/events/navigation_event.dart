import 'package:sharezone_common/helper_functions.dart';
import 'package:analytics/analytics.dart';

class NavigationEvent extends AnalyticsEvent {
  NavigationEvent(String name)
      : assert(isNotEmptyOrNull(name)),
        super("navigation_$name");
}
