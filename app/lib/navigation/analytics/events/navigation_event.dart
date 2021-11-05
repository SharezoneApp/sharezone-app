import 'package:analytics/analytics.dart';
import 'package:sharezone_common/helper_functions.dart';

class NavigationEvent extends AnalyticsEvent {
  NavigationEvent(String name)
      : assert(isNotEmptyOrNull(name)),
        super("navigation_$name");
}
