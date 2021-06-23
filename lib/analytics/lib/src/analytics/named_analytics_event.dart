import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';
import '../../analytics.dart';

class NamedAnalyticsEvent extends AnalyticsEvent {
  NamedAnalyticsEvent({@required String name})
      : assert(isNotEmptyOrNull(name)),
        super(name);

  @override
  Map<String, dynamic> get data => {};
}
