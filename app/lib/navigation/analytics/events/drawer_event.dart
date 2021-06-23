import 'package:sharezone_common/helper_functions.dart';

import 'navigation_event.dart';

class DrawerEvent extends NavigationEvent {
  DrawerEvent(String name)
      : assert(isNotEmptyOrNull(name)),
        super("drawer_$name");
}
