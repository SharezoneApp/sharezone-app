import 'package:sharezone/navigation/analytics/events/navigation_event.dart';
import 'package:sharezone_common/helper_functions.dart';

class NavBottomBar extends NavigationEvent {
  NavBottomBar(String name)
      : assert(isNotEmptyOrNull(name)),
        super("nav_bottom_bar_$name");
}
